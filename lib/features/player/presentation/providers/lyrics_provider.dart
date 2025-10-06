import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lyrics_provider.g.dart';

Future<bool> _isConnected() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

@riverpod
Future<String> lyrics(Ref ref,
    {required String artist, required String track}) async {

  final hasConnection = await _isConnected();
  if (!hasConnection) {
    return 'No hay conexión a internet para buscar la letra.';
  }

  final dio = Dio();
  final url = 'https://api.lyrics.ovh/v1/$artist/$track';

  try {
    final response = await dio.get(Uri.encodeFull(url));
    if (response.data != null && response.data['lyrics'] != null && response.data['lyrics'].toString().trim().isNotEmpty) {
      return response.data['lyrics'].toString().trim();
    } else {
      throw Exception();
    }
  } catch (e) {
    return 'Letra no disponible para esta canción.';
  }
}