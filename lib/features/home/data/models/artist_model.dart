import '../../domain/entities/artist.dart';

class ArtistModel extends Artist {
  const ArtistModel({
    required super.id,
    required super.name,
    required super.pictureMedium,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Artista Desconocido',
      pictureMedium: json['picture_medium'] ?? '',
    );
  }
}