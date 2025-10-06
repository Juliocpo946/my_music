import '../../domain/entities/track.dart';
import 'artist_model.dart';

class TrackModel extends Track {
  const TrackModel({
    required super.id,
    required super.title,
    required super.preview,
    required super.artist,
    required super.albumId,
    required super.albumTitle,
    required super.albumCover,
    required super.duration,
    super.isLocal,
    super.filePath,
    super.embeddedPicture,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    final album = json.containsKey('album') && json['album'] is Map
        ? json['album']
        : <String, dynamic>{};

    return TrackModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Canción Desconocida',
      preview: json['preview'] ?? '',
      artist: ArtistModel.fromJson(json['artist'] ?? {}),
      albumId: album['id'] ?? 0,
      albumTitle: album['title'] ?? '',
      albumCover: album['cover_small'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }
}