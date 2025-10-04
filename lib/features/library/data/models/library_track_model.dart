import 'package:my_music/features/home/data/models/artist_model.dart';
import 'package:my_music/features/home/data/models/track_model.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import '../../domain/entities/library_track.dart';

class LibraryTrackModel extends LibraryTrack {
  const LibraryTrackModel(
      {required super.id,
        required super.title,
        required super.preview,
        required super.artist,
        required super.albumId,
        required super.albumTitle,
        required super.albumCover,
        required super.duration});

  factory LibraryTrackModel.fromTrack(Track track) {
    return LibraryTrackModel(
      id: track.id,
      title: track.title,
      preview: track.preview,
      artist: track.artist,
      albumId: track.albumId,
      albumTitle: track.albumTitle,
      albumCover: track.albumCover,
      duration: track.duration,
    );
  }

  factory LibraryTrackModel.fromMap(Map<String, dynamic> map) {
    return LibraryTrackModel(
      id: map['id'],
      title: map['title'],
      preview: map['preview'],
      artist: ArtistModel(
          id: map['artistId'],
          name: map['artistName'],
          pictureMedium: map['artistPicture']),
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
      'artistId': artist.id,
      'artistName': artist.name,
      'artistPicture': artist.pictureMedium,
      'albumId': albumId,
      'albumTitle': albumTitle,
      'albumCover': albumCover,
      'duration': duration,
    };
  }

  TrackModel toTrackModel() {
    return TrackModel(
        id: id,
        title: title,
        preview: preview,
        artist: artist,
        albumId: albumId,
        albumTitle: albumTitle,
        albumCover: albumCover,
        duration: duration);
  }
}