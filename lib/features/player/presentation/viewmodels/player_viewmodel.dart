import 'dart:async';
import 'package:collection/collection.dart';
import 'package:just_audio/just_audio.dart' hide PlayerState;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import 'package:my_music/features/player/domain/entities/player_state.dart';

part 'player_viewmodel.g.dart';

@riverpod
class PlayerViewModel extends _$PlayerViewModel {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _sequenceSubscription;
  StreamSubscription? _durationSubscription;

  List<Track> _currentQueue = [];

  @override
  PlayerState build() {
    _listenToPlayerChanges();

    ref.onDispose(() {
      _playerStateSubscription?.cancel();
      _positionSubscription?.cancel();
      _sequenceSubscription?.cancel();
      _durationSubscription?.cancel();
      _audioPlayer.dispose();
    });

    return const PlayerState();
  }

  void _listenToPlayerChanges() {
    _playerStateSubscription =
        _audioPlayer.playerStateStream.listen((playerState) {
          state = state.copyWith(isPlaying: playerState.playing);
        });

    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      state = state.copyWith(position: position);
    });

    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      state = state.copyWith(duration: duration ?? Duration.zero);
    });

    _sequenceSubscription =
        _audioPlayer.sequenceStateStream.listen((sequenceState) {
          if (sequenceState == null) return;
          final currentItem = sequenceState.currentSource;
          if (currentItem == null) {
            state = state.copyWith(clearCurrentTrack: true);
            return;
          }

          final track = _currentQueue.firstWhereOrNull(
                  (t) => t.id.toString() == currentItem.tag as String);

          state = state.copyWith(
            currentTrack: track,
            queue: _currentQueue,
          );
        });
  }

  Future<void> playTrack(Track track, {List<Track>? queue}) async {
    _currentQueue = queue ?? [track];

    final audioSources = _currentQueue.map((track) {
      if (track.isLocal && track.filePath != null) {
        return AudioSource.file(track.filePath!, tag: track.id.toString());
      } else {
        return AudioSource.uri(Uri.parse(track.preview),
            tag: track.id.toString());
      }
    }).toList();

    final playlist = ConcatenatingAudioSource(children: audioSources);
    final initialIndex = _currentQueue
        .indexWhere((t) => t.id == track.id && t.filePath == track.filePath);

    try {
      await _audioPlayer.setAudioSource(playlist,
          initialIndex: initialIndex >= 0 ? initialIndex : 0);
      state = state.copyWith(queue: _currentQueue);
      resume();
    } catch (e) {
      //
    }
  }

  Future<void> removeTrackFromQueue(Track track) async {
    final index = _currentQueue
        .indexWhere((t) => t.id == track.id && t.filePath == track.filePath);

    if (index != -1) {
      _currentQueue.removeAt(index);

      final audioSource = _audioPlayer.audioSource;
      if (audioSource is ConcatenatingAudioSource) {
        await audioSource.removeAt(index);
      }

      state = state.copyWith(queue: List.from(_currentQueue));
    }
  }

  void playTrackFromQueue(Track track) {
    final index = _currentQueue
        .indexWhere((t) => t.id == track.id && t.filePath == track.filePath);
    if (index != -1) {
      _audioPlayer.seek(Duration.zero, index: index);
    }
  }

  void cyclePlaybackMode() {
    final currentMode = state.playbackMode;
    final nextMode = switch (currentMode) {
      PlaybackMode.normal => PlaybackMode.loopAll,
      PlaybackMode.loopAll => PlaybackMode.loopOne,
      PlaybackMode.loopOne => PlaybackMode.shuffle,
      PlaybackMode.shuffle => PlaybackMode.normal,
    };

    switch (nextMode) {
      case PlaybackMode.normal:
        _audioPlayer.setLoopMode(LoopMode.off);
        _audioPlayer.setShuffleModeEnabled(false);
        break;
      case PlaybackMode.loopAll:
        _audioPlayer.setLoopMode(LoopMode.all);
        _audioPlayer.setShuffleModeEnabled(false);
        break;
      case PlaybackMode.loopOne:
        _audioPlayer.setLoopMode(LoopMode.one);
        _audioPlayer.setShuffleModeEnabled(false);
        break;
      case PlaybackMode.shuffle:
        _audioPlayer.setLoopMode(LoopMode.all);
        _audioPlayer.setShuffleModeEnabled(true);
        break;
    }
    state = state.copyWith(playbackMode: nextMode);
  }

  void resume() => _audioPlayer.play();
  void pause() => _audioPlayer.pause();
  void seek(Duration position) => _audioPlayer.seek(position);
  void nextTrack() => _audioPlayer.seekToNext();
  void previousTrack() => _audioPlayer.seekToPrevious();
}