import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music/features/home/domain/entities/track.dart';

MediaItem _trackToMediaItem(Track track) {
  return MediaItem(
    id: track.id.toString(),
    album: track.albumTitle,
    title: track.title,
    artist: track.artist.name,
    duration: Duration(seconds: track.duration),
    artUri: (track.isLocal || track.albumCover.isEmpty) ? null : Uri.parse(track.albumCover),
    extras: <String, dynamic>{
      'url': track.isLocal ? track.filePath! : track.preview,
      'isLocal': track.isLocal,
      'filePath': track.filePath,
      'albumCover': track.albumCover
    },
  );
}

class AudioPlayerHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  List<Track> _trackQueue = [];

  AudioPlayerHandler() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
  }

  Future<void> _loadEmptyPlaylist() async {
    await _player.setAudioSource(_playlist);
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[_player.loopMode]!,
        shuffleMode: _player.shuffleModeEnabled
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
      ));
    });
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      final oldMediaItem = mediaItem.value;
      if (duration != null && oldMediaItem != null && oldMediaItem.duration != duration) {
        mediaItem.add(oldMediaItem.copyWith(duration: duration));
      }
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      if (index != null && queue.value.isNotEmpty && index < queue.value.length) {
        mediaItem.add(queue.value[index]);
      }
    });
  }

  AudioSource _createAudioSource(MediaItem mediaItem) {
    final isLocal = mediaItem.extras?['isLocal'] ?? false;
    final url = mediaItem.extras!['url'];
    return isLocal
        ? AudioSource.file(url, tag: mediaItem)
        : AudioSource.uri(Uri.parse(url), tag: mediaItem);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> onTaskRemoved() async {
    await stop();
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= _playlist.children.length) return;
    await _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    if (index < 0 || index >= _playlist.children.length) return;
    await _playlist.removeAt(index);
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  Future<void> playTrack(Track track, {List<Track>? newQueue}) async {
    _trackQueue = newQueue ?? [track];
    final mediaItems = _trackQueue.map(_trackToMediaItem).toList();
    final audioSources = mediaItems.map(_createAudioSource).toList();

    await _playlist.clear();
    await _playlist.addAll(audioSources);
    queue.add(mediaItems);

    final index = _trackQueue.indexWhere((t) => t.id == track.id && t.filePath == track.filePath);

    if (index != -1) {
      mediaItem.add(mediaItems[index]);
      await skipToQueueItem(index);
      play();
    }
  }

  Future<void> cyclePlaybackMode() async {
    final currentLoopMode = _player.loopMode;
    final currentShuffleEnabled = _player.shuffleModeEnabled;

    if (currentLoopMode == LoopMode.off && !currentShuffleEnabled) {
      await _player.setLoopMode(LoopMode.all);
    } else if (currentLoopMode == LoopMode.all && !currentShuffleEnabled) {
      await _player.setLoopMode(LoopMode.one);
    } else if (currentLoopMode == LoopMode.one) {
      await _player.setShuffleModeEnabled(true);
      await _player.setLoopMode(LoopMode.all);
    } else {
      await _player.setShuffleModeEnabled(false);
      await _player.setLoopMode(LoopMode.off);
    }
  }
}