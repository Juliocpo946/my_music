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
}