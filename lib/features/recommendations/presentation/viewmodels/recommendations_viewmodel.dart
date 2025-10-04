import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_music/core/providers/dio_provider.dart';
import 'package:my_music/core/providers/settings_provider.dart';
import 'package:my_music/features/home/domain/entities/album.dart';
import 'package:my_music/features/recommendations/data/datasources/recommendations_remote_datasource.dart';
import 'package:my_music/features/recommendations/data/repositories/recommendations_repository_impl.dart';
import 'package:my_music/features/recommendations/domain/usecases/get_album_recommendations.dart';

part 'recommendations_viewmodel.g.dart';

@riverpod
Future<List<Album>> recommendationsViewModel(RecommendationsViewModelRef ref) {
  final dio = ref.watch(dioProvider);
  final settingsRepository = ref.watch(settingsRepositoryProvider);

  final remoteDataSource = RecommendationsRemoteDataSourceImpl(dio: dio);
  final repository = RecommendationsRepositoryImpl(
    remoteDataSource: remoteDataSource,
    settingsRepository: settingsRepository,
  );
  final getAlbumRecommendations = GetAlbumRecommendations(repository);

  return getAlbumRecommendations();
}