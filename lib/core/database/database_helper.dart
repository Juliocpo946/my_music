import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('music_v8.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 5, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future _createDB(Database db, int version) async {
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const blobType = 'BLOB';

    await db.execute('''
    CREATE TABLE library_tracks ( 
      id INTEGER PRIMARY KEY, 
      title $textType, 
      preview $textType, 
      artistId $integerType, 
      artistName $textType, 
      artistPicture TEXT, 
      albumId $integerType, 
      albumTitle $textType, 
      albumCover $textType, 
      duration $integerType,
      isLocal INTEGER NOT NULL DEFAULT 0,
      filePath TEXT,
      albumArt $blobType
      )
    ''');
    await db.execute('CREATE TABLE favorite_tracks (id INTEGER PRIMARY KEY)');
    await db.execute(
        'CREATE TABLE playlists (id INTEGER PRIMARY KEY AUTOINCREMENT, name $textType)');
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
      isLocal INTEGER NOT NULL DEFAULT 0,
      filePath TEXT,
      FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE
    )
    ''');
    await db.execute(
        'CREATE TABLE user_settings (key TEXT PRIMARY KEY, value TEXT)');
    await db
        .execute('CREATE TABLE user_genres (name TEXT PRIMARY KEY)');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS library_tracks');
    await db.execute('DROP TABLE IF EXISTS favorite_tracks');
    await db.execute('DROP TABLE IF EXISTS playlists');
    await db.execute('DROP TABLE IF EXISTS playlist_tracks');
    await db.execute('DROP TABLE IF EXISTS user_settings');
    await db.execute('DROP TABLE IF EXISTS user_genres');
    await _createDB(db, newVersion);
  }
}