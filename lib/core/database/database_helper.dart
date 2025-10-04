import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('music.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path,
        version: 4, onCreate: _createDB, onUpgrade: _onUpgradeDB);
  }

  Future _createDB(Database db, int version) async {
    await _executeSchema(db);
  }

  Future _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 4) {
      await _executeSchema(db);
    }
  }

  Future<void> _executeSchema(Database db) async {
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('DROP TABLE IF EXISTS library_tracks');
    await db.execute('DROP TABLE IF EXISTS favorite_tracks');
    await db.execute('DROP TABLE IF EXISTS playlists');
    await db.execute('DROP TABLE IF EXISTS playlist_tracks');

    await db.execute('''
    CREATE TABLE library_tracks ( 
      id INTEGER PRIMARY KEY, 
      title $textType,
      preview $textType,
      artistId $integerType,
      artistName $textType,
      artistPicture $textType,
      albumId $integerType,
      albumTitle $textType,
      albumCover $textType,
      duration $integerType
      )
    ''');

    await db.execute('''
    CREATE TABLE favorite_tracks (
      id INTEGER PRIMARY KEY
    )
    ''');

    await db.execute('''
    CREATE TABLE playlists (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE playlist_tracks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      playlist_id INTEGER,
      track_id INTEGER,
      title $textType,
      preview $textType,
      artistName $textType,
      albumCover $textType,
      duration $integerType,
      FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE
    )
    ''');
  }
}