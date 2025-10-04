import 'dart:math';
import 'package:my_music/core/providers/settings_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/models/track_model.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/entities/track.dart';
import '../../domain/usecases/get_home_data.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<HomeData> homeViewModel(HomeViewModelRef ref) async {
  final dio = ref.watch(dioProvider);
  final settingsRepository = ref.watch(settingsRepositoryProvider);

  final dataSource = HomeRemoteDataSourceImpl(dio: dio);
  final repository = HomeRepositoryImpl(remoteDataSource: dataSource);
  final getHomeData = GetHomeData(repository);

  final homeData = await getHomeData();

  final userName = await settingsRepository.getUserName() ?? '';
  final userGenres = await settingsRepository.getGenres();

  List<Track> recommendations = [];
  if (userGenres.isNotEmpty) {
    try {
      final randomGenre = userGenres[Random().nextInt(userGenres.length)];
      final searchResponse = await dio
          .get('/search/track', queryParameters: {'q': 'genre:"$randomGenre"'});
      recommendations = (searchResponse.data['data'] as List)
          .map((item) => TrackModel.fromJson(item))
          .toList()
          .take(5)
          .toList();
    } catch (e) {
      // Ignorar error de recomendación
    }
  }

  homeData.userName = userName;
  homeData.recommendations = recommendations;

  return homeData;
}