import '../../domain/entities/artist.dart';

class ArtistModel extends Artist {
  const ArtistModel({
    required super.id,
    required super.name,
    required super.pictureMedium,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['id'] == 0) {
      throw Exception('Invalid artist data from API');
    }
    return ArtistModel(
      id: json['id'],
      name: json['name'] ?? 'Artista Desconocido',
      pictureMedium: json['picture_medium'] ?? '',
    );
  }
}