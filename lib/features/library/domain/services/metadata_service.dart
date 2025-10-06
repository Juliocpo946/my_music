import 'package:flutter/services.dart';

class MetadataService {
  static const _platform = MethodChannel('com.juliocpo946.mymusic/metadata');

  Future<List<Map<dynamic, dynamic>>> scanLocalSongs() async {
    try {
      final List<dynamic>? result = await _platform.invokeMethod('scanLocalSongs');
      if (result == null) return [];
      return result.cast<Map<dynamic, dynamic>>();
    } on PlatformException {
      return [];
    }
  }

  Future<bool> deleteLocalFile(String filePath) async {
    try {
      final bool? deleted = await _platform.invokeMethod('deleteLocalFile', {'filePath': filePath});
      return deleted ?? false;
    } on PlatformException catch (e) {
      print("Failed to delete file: '${e.message}'.");
      return false;
    }
  }
}