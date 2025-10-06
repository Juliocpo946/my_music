import 'package:sqflite/sqflite.dart';
import 'package:my_music/core/database/database_helper.dart';
import 'package:my_music/features/home/data/models/album_model.dart';
import 'package:my_music/features/home/data/models/artist_model.dart';
import 'package:my_music/features/home/data/models/track_model.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import '../models/library_track_model.dart';
import '../models/playlist_model.dart';

abstract class LibraryLocalDataSource {
  Future<void> addTrackToLibrary(Track track);
  Future<void> addMultipleTracksToLibrary(List<Track> tracks);
  Future<void> removeTrackFromLibrary(int trackId);
  Future<List<TrackModel>> getLibraryTracks();
  Future<bool> isInLibrary(int trackId);

  Future<void> addFavorite(int trackId);
  Future<void> removeFavorite(int trackId);
  Future<List<int>> getFavoriteTrackIds();
  Future<bool> isFavorite(int trackId);

  Future<List<PlaylistModel>> getPlaylists();
  Future<List<AlbumModel>> getLibraryAlbums();
  Future<List<ArtistModel>> getLibraryArtists();
  Future<void> createPlaylist(String name);
  Future<void> addTrackToPlaylist(int playlistId, Track track);
  Future<void> deletePlaylist(int playlistId);
  Future<List<String>> getFolders();
  Future<List<TrackModel>> getTracksByFolder(String folderPath);
  Future<void> clearLocalSongs();
}

class LibraryLocalDataSourceImpl implements LibraryLocalDataSource {
  final dbHelper = DatabaseHelper.instance;

  @override
  Future<void> addTrackToPlaylist(int playlistId, Track track) async {
    final db = await dbHelper.database;
    await db.insert(
      'playlist_tracks',
      {
        'playlist_id': playlistId,
        'track_id': track.id,
        'title': track.title,
        'preview': track.preview,
        'artistName': track.artist.name,
        'albumCover': track.albumCover,
        'duration': track.duration,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> addTrackToLibrary(Track track) async {
    final db = await dbHelper.database;
    await db.insert(
      'library_tracks',
      LibraryTrackModel.fromTrack(track).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> addMultipleTracksToLibrary(List<Track> tracks) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    for (final track in tracks) {
      batch.insert(
        'library_tracks',
        LibraryTrackModel.fromTrack(track).toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> removeTrackFromLibrary(int trackId) async {
    final db = await dbHelper.database;
    await db.delete(
      'library_tracks',
      where: 'id = ?',
      whereArgs: [trackId],
    );
  }

  @override
  Future<List<TrackModel>> getLibraryTracks() async {
    final db = await dbHelper.database;
    final maps = await db.query('library_tracks');
    return List.generate(maps.length, (i) {
      final model = LibraryTrackModel.fromMap(maps[i]);
      return model.toTrackModel();
    });
  }

  @override
  Future<bool> isInLibrary(int trackId) async {
    final db = await dbHelper.database;
    final maps =
    await db.query('library_tracks', where: 'id = ?', whereArgs: [trackId]);
    return maps.isNotEmpty;
  }

  @override
  Future<void> addFavorite(int trackId) async {
    final db = await dbHelper.database;
    await db.insert('favorite_tracks', {'id': trackId},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> removeFavorite(int trackId) async {
    final db = await dbHelper.database;
    await db.delete('favorite_tracks', where: 'id = ?', whereArgs: [trackId]);
  }

  @override
  Future<List<int>> getFavoriteTrackIds() async {
    final db = await dbHelper.database;
    final maps = await db.query('favorite_tracks');
    return List.generate(maps.length, (i) => maps[i]['id'] as int);
  }

  @override
  Future<bool> isFavorite(int trackId) async {
    final db = await dbHelper.database;
    final maps =
    await db.query('favorite_tracks', where: 'id = ?', whereArgs: [trackId]);
    return maps.isNotEmpty;
  }

  @override
  Future<List<PlaylistModel>> getPlaylists() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.id, p.name, COUNT(pt.id) as trackCount
      FROM playlists p
      LEFT JOIN playlist_tracks pt ON p.id = pt.playlist_id
      GROUP BY p.id, p.name
      ORDER BY p.name
    ''');
    return List.generate(maps.length, (i) {
      return PlaylistModel.fromMap(maps[i]);
    });
  }

  @override
  Future<List<AlbumModel>> getLibraryAlbums() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'library_tracks',
      distinct: true,
      columns: ['albumId', 'albumTitle', 'albumCover', 'artistName'],
      orderBy: 'albumTitle',
    );
    return List.generate(maps.length, (i) {
      return AlbumModel(
        id: maps[i]['albumId'],
        title: maps[i]['albumTitle'],
        coverMedium: maps[i]['albumCover'],
        artistName: maps[i]['artistName'],
      );
    });
  }

  @override
  Future<List<ArtistModel>> getLibraryArtists() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'library_tracks',
      distinct: true,
      columns: ['artistId', 'artistName', 'artistPicture'],
      orderBy: 'artistName',
    );
    return List.generate(maps.length, (i) {
      return ArtistModel(
        id: maps[i]['artistId'],
        name: maps[i]['artistName'],
        pictureMedium: maps[i]['artistPicture'],
      );
    });
  }

  @override
  Future<void> createPlaylist(String name) async {
    final db = await dbHelper.database;
    await db.insert('playlists', {'name': name});
  }

  @override
  Future<void> deletePlaylist(int playlistId) async {
    final db = await dbHelper.database;
    await db.delete('playlists', where: 'id = ?', whereArgs: [playlistId]);
  }
  @override
  Future<List<String>> getFolders() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'library_tracks',
      distinct: true,
      columns: ['filePath'],
    );

    final paths = maps.map((map) => (map['filePath'] as String)).toList();
    final folderPaths = paths.map((path) {
      return path.substring(0, path.lastIndexOf('/'));
    }).toSet().toList();

    return folderPaths;
  }

  @override
  Future<List<TrackModel>> getTracksByFolder(String folderPath) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'library_tracks',
      where: 'filePath LIKE ?',
      whereArgs: ['$folderPath%'],
    );
    return List.generate(maps.length, (i) {
      final model = LibraryTrackModel.fromMap(maps[i]);
      return model.toTrackModel();
    });
  }

  @override
  Future<void> clearLocalSongs() async {
    final db = await dbHelper.database;
    await db.delete('library_tracks', where: 'filePath IS NOT NULL');
  }
}