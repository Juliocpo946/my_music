import 'package:equatable/equatable.dart';
import 'package:my_music/features/home/domain/entities/track.dart';

enum PlaybackMode { normal, loopAll, loopOne, shuffle }

class PlayerState extends Equatable {
  final Track? currentTrack;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final PlaybackMode playbackMode;
  final List<Track> queue;

  const PlayerState({
    this.currentTrack,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.playbackMode = PlaybackMode.normal,
    this.queue = const [],
  });

  PlayerState copyWith({
    Track? currentTrack,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    PlaybackMode? playbackMode,
    List<Track>? queue,
    bool clearCurrentTrack = false,
  }) {
    return PlayerState(
      currentTrack: clearCurrentTrack ? null : currentTrack ?? this.currentTrack,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      playbackMode: playbackMode ?? this.playbackMode,
      queue: queue ?? this.queue,
    );
  }

  @override
  List<Object?> get props =>
      [currentTrack, isPlaying, position, duration, playbackMode, queue];
}