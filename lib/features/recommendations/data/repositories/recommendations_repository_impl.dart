import 'dart:math';
import 'package:my_music/features/home/domain/entities/album.dart';
import 'package:my_music/features/settings/domain/repositories/settings_repository.dart';
import '../../domain/repositories/recommendations_repository.dart';
import '../datasources/recommendations_remote_datasource.dart';

class RecommendationsRepositoryImpl implements RecommendationsRepository {
  final RecommendationsRemoteDataSource remoteDataSource;
  final SettingsRepository settingsRepository;

  RecommendationsRepositoryImpl({
    required this.remoteDataSource,
    required this.settingsRepository,
  });

  @override
  Future<List<Album>> getAlbumRecommendations() async {
    final userGenres = await settingsRepository.getGenres();
    if (userGenres.isEmpty) {
      return [];
    }
    final randomGenre = userGenres[Random().nextInt(userGenres.length)];
    return remoteDataSource.getAlbumsByGenre(randomGenre);
  }
}