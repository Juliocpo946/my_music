import '../../domain/entities/album.dart';

class AlbumModel extends Album {
  const AlbumModel({
    required super.id,
    required super.title,
    required super.coverMedium,
    required super.artistName,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['id'] == 0) {
      throw Exception('Invalid album data from API');
    }
    return AlbumModel(
      id: json['id'],
      title: json['title'] ?? 'Álbum Desconocido',
      coverMedium: json['cover_medium'] ?? '',
      artistName: json.containsKey('artist') && json['artist'] is Map
          ? json['artist']['name'] ?? 'Artista Desconocido'
          : 'Artista Desconocido',
    );
  }
}