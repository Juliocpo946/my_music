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
  Future<List<TrackModel>> getTracksForAlbum(int albumId);
  Future<List<TrackModel>> getTracksForArtist(int artistId);
  Future<List<TrackModel>> getTracksByAlbumTitle(String albumTitle);
  Future<List<TrackModel>> getTracksByArtistName(String artistName);

  Future<void> hideTrack(String filePath);
  Future<void> unhideTrack(String filePath);
  Future<List<TrackModel>> getHiddenTracks();
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
    final maps = await db.rawQuery('''
      SELECT * FROM library_tracks
      WHERE filePath IS NULL OR filePath NOT IN (SELECT filePath FROM hidden_tracks)
    ''');
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
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT DISTINCT albumId, albumTitle, albumCover, artistName
      FROM library_tracks
      WHERE isLocal = 0 OR (
        isLocal = 1 AND (
          SELECT COUNT(*) FROM library_tracks AS t 
          WHERE t.albumId = library_tracks.albumId AND (t.filePath IS NULL OR t.filePath NOT IN (SELECT filePath FROM hidden_tracks))
        ) > 0
      )
      ORDER BY albumTitle
    ''');
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
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT DISTINCT artistId, artistName, artistPicture
      FROM library_tracks
      WHERE isLocal = 0 OR (
        isLocal = 1 AND (
          SELECT COUNT(*) FROM library_tracks AS t 
          WHERE t.artistId = library_tracks.artistId AND (t.filePath IS NULL OR t.filePath NOT IN (SELECT filePath FROM hidden_tracks))
        ) > 0
      )
      ORDER BY artistName
    ''');
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
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT DISTINCT SUBSTR(filePath, 1, LENGTH(filePath) - INSTR(REVERSE(filePath), '/')) as folderPath
      FROM library_tracks
      WHERE isLocal = 1 AND filePath IS NOT NULL
        AND (
          SELECT COUNT(*) FROM library_tracks AS t
          WHERE SUBSTR(t.filePath, 1, LENGTH(t.filePath) - INSTR(REVERSE(t.filePath), '/')) = folderPath
            AND (t.filePath NOT IN (SELECT filePath FROM hidden_tracks))
        ) > 0
    ''');
    return maps.map((map) => map['folderPath'] as String).toList();
  }

  @override
  Future<List<TrackModel>> getTracksByFolder(String folderPath) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'library_tracks',
      where: 'filePath LIKE ? AND (filePath IS NULL OR filePath NOT IN (SELECT filePath FROM hidden_tracks))',
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

  @override
  Future<List<TrackModel>> getTracksForAlbum(int albumId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
        'library_tracks',
        where: 'albumId = ? AND (filePath IS NULL OR filePath NOT IN (SELECT filePath FROM hidden_tracks))',
        whereArgs: [albumId]);
    return List.generate(maps.length, (i) {
      final model = LibraryTrackModel.fromMap(maps[i]);
      return model.toTrackModel();
    });
  }

  @override
  Future<List<TrackModel>> getTracksForArtist(int artistId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
        'library_tracks',
        where: 'artistId = ? AND (filePath IS NULL OR filePath NOT IN (SELECT filePath FROM hidden_tracks))',
        whereArgs: [artistId]);
    return List.generate(maps.length, (i) {
      final model = LibraryTrackModel.fromMap(maps[i]);
      return model.toTrackModel();
    });
  }

  @override
  Future<List<TrackModel>> getTracksByAlbumTitle(String albumTitle) async {
    final db = await dbHelper.database;
    final maps = await db.query(
        'library_tracks',
        where: 'albumTitle = ? AND isLocal = 1 AND (filePath IS NULL OR filePath NOT IN (SELECT filePath FROM hidden_tracks))',
        whereArgs: [albumTitle]);
    return List.generate(maps.length, (i) {
      final model = LibraryTrackModel.fromMap(maps[i]);
      return model.toTrackModel();
    });
  }

  @override
  Future<List<TrackModel>> getTracksByArtistName(String artistName) async {
    final db = await dbHelper.database;
    final maps = await db.query(
        'library_tracks',
        where: 'artistName = ? AND isLocal = 1 AND (filePath IS NULL OR filePath NOT IN (SELECT filePath FROM hidden_tracks))',
        whereArgs: [artistName]);
    return List.generate(maps.length, (i) {
      final model = LibraryTrackModel.fromMap(maps[i]);
      return model.toTrackModel();
    });
  }

  @override
  Future<void> hideTrack(String filePath) async {
    final db = await dbHelper.database;
    await db.insert('hidden_tracks', {'filePath': filePath},
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  @override
  Future<void> unhideTrack(String filePath) async {
    final db = await dbHelper.database;
    await db
        .delete('hidden_tracks', where: 'filePath = ?', whereArgs: [filePath]);
  }

  @override
  Future<List<TrackModel>> getHiddenTracks() async {
    final db = await dbHelper.database;
    final hiddenPathsResult = await db.query('hidden_tracks');
    if (hiddenPathsResult.isEmpty) {
      return [];
    }
    final hiddenPaths =
    hiddenPathsResult.map((row) => row['filePath'] as String).toList();

    final placeholders = ('?' * hiddenPaths.length).split('').join(',');
    final maps = await db.query('library_tracks',
        where: 'filePath IN ($placeholders)', whereArgs: hiddenPaths);

    return List.generate(maps.length, (i) {
      final model = LibraryTrackModel.fromMap(maps[i]);
      return model.toTrackModel();
    });
  }
}