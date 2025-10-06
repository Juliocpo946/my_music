import 'dart:async';
import 'dart:math';
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

  List<Track> _queue = [];
  int _currentIndex = -1;
  bool _shuffle = false;

  @override
  PlayerState build() {
    _playerStateSubscription?.cancel();
    _playerStateSubscription =
        _audioPlayer.playerStateStream.listen((playerState) {
          if (playerState.processingState == ProcessingState.completed) {
            if (_audioPlayer.loopMode == LoopMode.one) {
              _audioPlayer.seek(Duration.zero);
              _audioPlayer.play();
            } else {
              nextTrack();
            }
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

  Future<void> playTrack(Track track, {List<Track>? queue}) async {
    if (queue != null) {
      _queue = queue;
      _currentIndex = _queue.indexWhere((t) => t.id == track.id && t.filePath == track.filePath);
    } else {
      _queue = [track];
      _currentIndex = 0;
    }

    try {
      if (track.isLocal && track.filePath != null) {
        await _audioPlayer.setFilePath(track.filePath!);
      } else {
        await _audioPlayer.setUrl(track.preview);
      }
      state = state.copyWith(
        currentTrack: track,
        duration: _audioPlayer.duration ?? Duration.zero,
      );
      resume();
    } catch (e) {
      //
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

  void nextTrack() {
    if (_queue.isEmpty || _currentIndex == -1) return;

    if (_shuffle) {
      _currentIndex = Random().nextInt(_queue.length);
    } else {
      _currentIndex = (_currentIndex + 1) % _queue.length;
    }
    playTrack(_queue[_currentIndex], queue: _queue);
  }

  void previousTrack() {
    if (_queue.isEmpty || _currentIndex == -1) return;

    if (_shuffle) {
      _currentIndex = Random().nextInt(_queue.length);
    } else {
      _currentIndex = (_currentIndex - 1 + _queue.length) % _queue.length;
    }
    playTrack(_queue[_currentIndex], queue: _queue);
  }

  void toggleShuffle() {
    _shuffle = !_shuffle;
  }

  void toggleLoopMode() {
    switch (_audioPlayer.loopMode) {
      case LoopMode.off:
        _audioPlayer.setLoopMode(LoopMode.all);
        break;
      case LoopMode.all:
        _audioPlayer.setLoopMode(LoopMode.one);
        break;
      case LoopMode.one:
        _audioPlayer.setLoopMode(LoopMode.off);
        break;
    }
  }

  void forward() {
    final newPosition = state.position + const Duration(seconds: 10);
    seek(newPosition < state.duration ? newPosition : state.duration);
  }

  void rewind() {
    final newPosition = state.position - const Duration(seconds: 10);
    seek(newPosition > Duration.zero ? newPosition : Duration.zero);
  }
}