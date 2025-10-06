import 'package:my_music/features/home/data/models/track_model.dart';
import '../../domain/entities/album_details.dart';

class AlbumDetailsModel extends AlbumDetails {
  const AlbumDetailsModel({
    required super.id,
    required super.title,
    required super.coverBig,
    required super.artistName,
    required super.tracks,
    required super.localTracks,
  });

  factory AlbumDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['id'] == 0) {
      throw Exception('Invalid album details data from API');
    }

    var tracksData = json['tracks']?['data'];
    List<TrackModel> tracks = [];
    if (tracksData is List) {
      tracks = tracksData.map((i) => TrackModel.fromJson(i)).toList();
    }

    return AlbumDetailsModel(
      id: json['id'],
      title: json['title'] ?? 'Álbum Desconocido',
      coverBig: json['cover_big'] ?? '',
      artistName: json['artist']?['name'] ?? 'Artista Desconocido',
      tracks: tracks,
      localTracks: const [],
    );
  }
}