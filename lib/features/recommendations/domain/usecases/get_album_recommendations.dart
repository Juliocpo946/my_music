import 'package:my_music/features/home/domain/entities/album.dart';
import '../repositories/recommendations_repository.dart';

class GetAlbumRecommendations {
  final RecommendationsRepository repository;

  GetAlbumRecommendations(this.repository);

  Future<List<Album>> call() async {
    return repository.getAlbumRecommendations();
  }
}