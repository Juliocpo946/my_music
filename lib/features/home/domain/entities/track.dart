import 'package:equatable/equatable.dart';
import 'artist.dart';

class Track extends Equatable {
  final int id;
  final String title;
  final String preview;
  final Artist artist;
  final int albumId;
  final String albumTitle;
  final String albumCover;
  final int duration;

  const Track({
    required this.id,
    required this.title,
    required this.preview,
    required this.artist,
    required this.albumId,
    required this.albumTitle,
    required this.albumCover,
    required this.duration,
  });

  @override
  List<Object?> get props => [id];
}