import 'package:my_music/core/database/database_helper.dart';
import 'package:my_music/features/home/data/models/track_model.dart';
import 'package:my_music/features/home/domain/entities/artist.dart';
import 'package:my_music/features/library/data/models/playlist_model.dart';

abstract class PlaylistDetailsLocalDataSource {
  Future<PlaylistModel> getPlaylistInfo(int playlistId);
  Future<List<TrackModel>> getTracksForPlaylist(int playlistId);
}

class PlaylistDetailsLocalDataSourceImpl implements PlaylistDetailsLocalDataSource {
  final dbHelper = DatabaseHelper.instance;

  @override
  Future<PlaylistModel> getPlaylistInfo(int playlistId) async {
    final db = await dbHelper.database;
    final maps = await db.query('playlists', where: 'id = ?', whereArgs: [playlistId]);
    if (maps.isNotEmpty) {
      final map = maps.first;
      final trackCountResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM playlist_tracks WHERE playlist_id = ?',
        [playlistId],
      );
      final trackCount = trackCountResult.first['count'] as int;
      return PlaylistModel(
        id: map['id'] as int,
        name: map['name'] as String,
        trackCount: trackCount,
      );
    } else {
      throw Exception('Playlist not found');
    }
  }

  @override
  Future<List<TrackModel>> getTracksForPlaylist(int playlistId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'playlist_tracks',
      where: 'playlist_id = ?',
      whereArgs: [playlistId],
    );

    return List.generate(maps.length, (i) {
      final map = maps[i];
      return TrackModel(
        id: map['track_id'] as int,
        title: map['title'] as String,
        preview: map['preview'] as String,
        artist: Artist(id: 0, name: map['artistName'] as String, pictureMedium: ''),
        albumId: 0,
        albumTitle: '',
        albumCover: map['albumCover'] as String,
        duration: map['duration'] as int,
      );
    });
  }
}