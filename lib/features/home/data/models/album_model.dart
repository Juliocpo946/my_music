import '../../domain/entities/album.dart';

class AlbumModel extends Album {
  const AlbumModel({
    required super.id,
    required super.title,
    required super.coverMedium,
    required super.artistName,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id'],
      title: json['title'],
      coverMedium: json['cover_medium'],
      artistName: json['artist']['name'],
    );
  }
}