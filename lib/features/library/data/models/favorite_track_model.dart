import 'package:my_music/features/home/domain/entities/track.dart';
import '../../domain/entities/favorite_track.dart';

class FavoriteTrackModel extends FavoriteTrack {
  const FavoriteTrackModel(
      {required super.id,
        required super.title,
        required super.preview,
        required super.artistId,
        required super.artistName,
        required super.artistPicture,
        required super.albumId,
        required super.albumTitle,
        required super.albumCover,
        required super.duration});

  factory FavoriteTrackModel.fromTrack(Track track) {
    return FavoriteTrackModel(
      id: track.id,
      title: track.title,
      preview: track.preview,
      artistId: track.artist.id,
      artistName: track.artist.name,
      artistPicture: track.artist.pictureMedium,
      albumId: track.albumId,
      albumTitle: track.albumTitle,
      albumCover: track.albumCover,
      duration: track.duration,
    );
  }

  factory FavoriteTrackModel.fromMap(Map<String, dynamic> map) {
    return FavoriteTrackModel(
      id: map['id'],
      title: map['title'],
      preview: map['preview'],
      artistId: map['artistId'],
      artistName: map['artistName'],
      artistPicture: map['artistPicture'],
      albumId: map['albumId'],
      albumTitle: map['albumTitle'],
      albumCover: map['albumCover'],
      duration: map['duration'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'preview': preview,
      'artistId': artistId,
      'artistName': artistName,
      'artistPicture': artistPicture,
      'albumId': albumId,
      'albumTitle': albumTitle,
      'albumCover': albumCover,
      'duration': duration,
    };
  }
}