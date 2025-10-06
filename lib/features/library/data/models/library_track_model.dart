import 'dart:typed_data';
import 'package:my_music/features/home/data/models/artist_model.dart';
import 'package:my_music/features/home/data/models/track_model.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import 'package:my_music/features/library/domain/entities/library_track.dart';

class LibraryTrackModel extends LibraryTrack {
  const LibraryTrackModel(
      {required super.id,
        required super.title,
        required super.preview,
        required super.artist,
        required super.albumId,
        required super.albumTitle,
        required super.albumCover,
        required super.duration,
        required super.isLocal,
        super.filePath,
        super.embeddedPicture});

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
      isLocal: track.isLocal,
      filePath: track.filePath,
      embeddedPicture: track.embeddedPicture,
    );
  }

  factory LibraryTrackModel.fromMap(Map<String, dynamic> map) {
    return LibraryTrackModel(
      id: map['id'] as int,
      title: map['title'] as String,
      preview: map['preview'] as String,
      artist: ArtistModel(
          id: map['artistId'] as int,
          name: map['artistName'] as String,
          pictureMedium: (map['artistPicture'] as String?) ?? ''),
      albumId: map['albumId'] as int,
      albumTitle: map['albumTitle'] as String,
      albumCover: map['albumCover'] as String,
      duration: map['duration'] as int,
      isLocal: (map['isLocal'] as int) == 1,
      filePath: map['filePath'] as String?,
      embeddedPicture: map['albumArt'] as Uint8List?,
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
      'isLocal': isLocal ? 1 : 0,
      'filePath': filePath,
      'albumArt': embeddedPicture,
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
      duration: duration,
      isLocal: isLocal,
      filePath: filePath,
      embeddedPicture: embeddedPicture,
    );
  }
}