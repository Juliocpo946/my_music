import 'package:equatable/equatable.dart';

class FavoriteTrack extends Equatable {
  final int id;
  final String title;
  final String preview;
  final int artistId;
  final String artistName;
  final String artistPicture;
  final int albumId;
  final String albumTitle;
  final String albumCover;
  final int duration;

  const FavoriteTrack({
    required this.id,
    required this.title,
    required this.preview,
    required this.artistId,
    required this.artistName,
    required this.artistPicture,
    required this.albumId,
    required this.albumTitle,
    required this.albumCover,
    required this.duration,
  });

  @override
  List<Object?> get props => [id];
}