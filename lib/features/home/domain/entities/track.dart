import 'package:equatable/equatable.dart';
import 'artist.dart';

class Track extends Equatable {
  final int id;
  final String title;
  final String preview;
  final Artist artist;
  final String albumCover;

  const Track({
    required this.id,
    required this.title,
    required this.preview,
    required this.artist,
    required this.albumCover,
  });

  @override
  List<Object?> get props => [id];
}