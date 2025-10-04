import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lyrics_provider.g.dart';

@riverpod
Future<String> lyrics(LyricsRef ref,
    {required String artist, required String track}) async {
  final dio = Dio();
  final url = 'https://api.lyrics.ovh/v1/$artist/$track';

  try {
    final response = await dio.get(Uri.encodeFull(url));
    if (response.data != null && response.data['lyrics'] != null) {
      return response.data['lyrics'].toString().trim();
    } else {
      throw Exception();
    }
  } catch (e) {
    return 'Letra no disponible para esta canción.';
  }
}