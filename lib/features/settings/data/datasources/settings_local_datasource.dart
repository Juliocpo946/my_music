import 'package:sqflite/sqflite.dart';
import 'package:my_music/core/database/database_helper.dart';

abstract class SettingsLocalDataSource {
  Future<void> saveSetting(String key, String value);
  Future<String?> getSetting(String key);
  Future<void> saveGenres(List<String> genres);
  Future<List<String>> getGenres();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final dbHelper = DatabaseHelper.instance;

  @override
  Future<String?> getSetting(String key) async {
    final db = await dbHelper.database;
    final result =
    await db.query('user_settings', where: 'key = ?', whereArgs: [key]);
    return result.isNotEmpty ? result.first['value'] as String? : null;
  }

  @override
  Future<void> saveSetting(String key, String value) async {
    final db = await dbHelper.database;
    await db.insert('user_settings', {'key': key, 'value': value},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<String>> getGenres() async {
    final db = await dbHelper.database;
    final result = await db.query('user_genres');
    return result.map((row) => row['name'] as String).toList();
  }

  @override
  Future<void> saveGenres(List<String> genres) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    batch.delete('user_genres');
    for (final genre in genres) {
      batch.insert('user_genres', {'name': genre});
    }
    await batch.commit(noResult: true);
  }
}