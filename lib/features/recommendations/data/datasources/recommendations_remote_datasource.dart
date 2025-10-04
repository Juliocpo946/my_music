import 'package:dio/dio.dart';
import 'package:my_music/features/home/data/models/album_model.dart';

abstract class RecommendationsRemoteDataSource {
  Future<List<AlbumModel>> getAlbumsByGenre(String genre);
}

class RecommendationsRemoteDataSourceImpl implements RecommendationsRemoteDataSource {
  final Dio dio;

  RecommendationsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<AlbumModel>> getAlbumsByGenre(String genre) async {
    final response = await dio.get('/search/album', queryParameters: {
      'q': 'genre:"$genre"',
      'limit': 50,
    });
    return (response.data['data'] as List)
        .map((item) => AlbumModel.fromJson(item))
        .toList();
  }
}