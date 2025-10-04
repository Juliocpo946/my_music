import '../../domain/entities/track.dart';
import 'artist_model.dart';

class TrackModel extends Track {
  const TrackModel({
    required super.id,
    required super.title,
    required super.preview,
    required super.artist,
    required super.albumCover,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
      id: json['id'],
      title: json['title'],
      preview: json['preview'],
      artist: ArtistModel.fromJson(json['artist']),
      albumCover: json['album']['cover_small'],
    );
  }
}