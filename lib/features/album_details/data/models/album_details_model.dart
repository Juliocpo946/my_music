import 'package:my_music/features/home/data/models/track_model.dart';
import '../../domain/entities/album_details.dart';

class AlbumDetailsModel extends AlbumDetails {
  const AlbumDetailsModel({
    required super.id,
    required super.title,
    required super.coverBig,
    required super.artistName,
    required super.tracks,
  });

  factory AlbumDetailsModel.fromJson(Map<String, dynamic> json) {
    var tracksData = json['tracks']?['data'];
    List<TrackModel> tracks = [];
    if (tracksData is List) {
      tracks = tracksData.map((i) => TrackModel.fromJson(i)).toList();
    }

    return AlbumDetailsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Álbum Desconocido',
      coverBig: json['cover_big'] ?? '',
      artistName: json['artist']?['name'] ?? 'Artista Desconocido',
      tracks: tracks,
    );
  }
}