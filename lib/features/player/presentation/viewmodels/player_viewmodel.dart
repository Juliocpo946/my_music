import 'dart:async';
import 'package:just_audio/just_audio.dart' hide PlayerState;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import 'package:my_music/features/player/domain/entities/player_state.dart';

part 'player_viewmodel.g.dart';

@riverpod
class PlayerViewModel extends _$PlayerViewModel {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  @override
  PlayerState build() {
    _playerStateSubscription?.cancel();
    _playerStateSubscription =
        _audioPlayer.playerStateStream.listen((playerState) {
          if (playerState.processingState == ProcessingState.completed) {
            state = state.copyWith(isPlaying: false, position: Duration.zero);
            _audioPlayer.seek(Duration.zero);
            _audioPlayer.pause();
          } else {
            state = state.copyWith(isPlaying: playerState.playing);
          }
        });

    _positionSubscription?.cancel();
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      state = state.copyWith(position: position);
    });

    ref.onDispose(() {
      _positionSubscription?.cancel();
      _playerStateSubscription?.cancel();
      _audioPlayer.dispose();
    });

    return const PlayerState();
  }

  Future<void> playTrack(Track track) async {
    try {
      if (state.currentTrack == track) {
        if (state.isPlaying) {
          pause();
        } else {
          resume();
        }
        return;
      }

      await _audioPlayer.setUrl(track.preview);
      state = state.copyWith(
        currentTrack: track,
        duration: _audioPlayer.duration ?? Duration.zero,
      );
      resume();
    } catch (e) {
      // Error handling
    }
  }

  void resume() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }
}