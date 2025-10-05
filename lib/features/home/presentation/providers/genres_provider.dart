import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_music/core/providers/dio_provider.dart';
import '../../data/datasources/home_remote_datasource.dart';

part 'genres_provider.g.dart';

@riverpod
Future<List<String>> genres(Ref ref) async {
  final dio = ref.watch(dioProvider);
  final dataSource = HomeRemoteDataSourceImpl(dio: dio);
  final allGenres = await dataSource.getGenres();
  final uniqueGenres = allGenres.toSet().toList();
  uniqueGenres.removeWhere((genre) => genre.toLowerCase() == 'all');
  return uniqueGenres;
}