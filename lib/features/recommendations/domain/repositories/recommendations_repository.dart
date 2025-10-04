import 'package:my_music/features/home/domain/entities/album.dart';

abstract class RecommendationsRepository {
  Future<List<Album>> getAlbumRecommendations();
}