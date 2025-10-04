import 'package:my_music/features/home/domain/entities/track.dart';

class LibraryTrack extends Track {
  const LibraryTrack({
    required super.id,
    required super.title,
    required super.preview,
    required super.artist,
    required super.albumId,
    required super.albumTitle,
    required super.albumCover,
    required super.duration,
  });
}