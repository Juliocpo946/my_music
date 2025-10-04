import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../network/dio_client.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(DioRef ref) {
  final client = DioClient(baseUrl: dotenv.env['DEEZER_BASE_URL']!);
  return client.dio;
}