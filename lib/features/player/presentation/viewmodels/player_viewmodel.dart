import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import 'package:my_music/features/home/domain/entities/artist.dart';
import 'package:my_music/features/player/domain/entities/player_state.dart';
import 'package:my_music/main.dart';

part 'player_viewmodel.g.dart';

@riverpod
class PlayerViewModel extends _$PlayerViewModel {
  StreamSubscription? _playbackStateSubscription;
  StreamSubscription? _mediaItemSubscription;
  StreamSubscription? _queueSubscription;

  @override
  PlayerState build() {
    _listenToAudioService();

    ref.onDispose(() {
      _playbackStateSubscription?.cancel();
      _mediaItemSubscription?.cancel();
      _queueSubscription?.cancel();
    });

    return const PlayerState();
  }

  void _listenToAudioService() {
    _playbackStateSubscription = audioHandler.playbackState.listen((playbackState) {

      final playbackMode = _mapToPlaybackMode(playbackState.repeatMode, playbackState.shuffleMode);

      state = state.copyWith(
        isPlaying: playbackState.playing,
        position: playbackState.updatePosition,
        duration: audioHandler.mediaItem.value?.duration ?? Duration.zero,
        playbackMode: playbackMode,
      );
    });

    _mediaItemSubscription = audioHandler.mediaItem.listen((mediaItem) {
      final track = mediaItem == null ? null : _mediaItemToTrack(mediaItem);
      // Solo actualizamos si el ID es diferente, para evitar reconstrucciones innecesarias
      // que podrían interferir con la actualización optimista.
      if (state.currentTrack?.id != track?.id) {
        state = state.copyWith(
          currentTrack: track,
          clearCurrentTrack: track == null,
          duration: mediaItem?.duration ?? Duration.zero,
        );
      }
    });

    _queueSubscription = audioHandler.queue.listen((queue) {
      final trackQueue = queue.map(_mediaItemToTrack).toList();
      state = state.copyWith(queue: trackQueue);
    });
  }

  PlaybackMode _mapToPlaybackMode(AudioServiceRepeatMode repeatMode, AudioServiceShuffleMode shuffleMode) {
    if (shuffleMode == AudioServiceShuffleMode.all) {
      return PlaybackMode.shuffle;
    }
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        return PlaybackMode.normal;
      case AudioServiceRepeatMode.one:
        return PlaybackMode.loopOne;
      case AudioServiceRepeatMode.all:
      case AudioServiceRepeatMode.group:
        return PlaybackMode.loopAll;
    }
  }

  Track _mediaItemToTrack(MediaItem mediaItem) {
    return Track(
      id: int.tryParse(mediaItem.id) ?? 0,
      title: mediaItem.title,
      preview: mediaItem.extras!['url'],
      artist: Artist(id: 0, name: mediaItem.artist ?? 'Desconocido', pictureMedium: ''),
      albumId: 0,
      albumTitle: mediaItem.album ?? 'Desconocido',
      albumCover: mediaItem.extras!['albumCover'] ?? '',
      duration: mediaItem.duration?.inSeconds ?? 0,
      isLocal: mediaItem.extras!['isLocal'],
      filePath: mediaItem.extras!['filePath'],
    );
  }

  Future<void> playTrack(Track track, {List<Track>? queue}) async {
    // Actualización optimista: actualiza la UI inmediatamente
    state = state.copyWith(
      currentTrack: track,
      isPlaying: true,
      queue: queue ?? [track],
    );
    // Luego, envía el comando al servicio de audio
    await audioHandler.playTrack(track, newQueue: queue);
  }

  Future<void> removeTrackFromQueue(Track track) async {
    final index = state.queue.indexWhere((t) => t.id == track.id && t.filePath == track.filePath);
    if(index != -1){
      await audioHandler.removeQueueItemAt(index);
    }
  }

  void playTrackFromQueue(Track track) {
    final index = state.queue.indexWhere((t) => t.id == track.id && t.filePath == track.filePath);
    if(index != -1){
      audioHandler.skipToQueueItem(index);
    }
  }

  void cyclePlaybackMode() {
    audioHandler.cyclePlaybackMode();
  }

  void resume() => audioHandler.play();
  void pause() => audioHandler.pause();
  void seek(Duration position) => audioHandler.seek(position);
  void nextTrack() => audioHandler.skipToNext();
  void previousTrack() => audioHandler.skipToPrevious();
}