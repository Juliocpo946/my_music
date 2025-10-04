import 'package:dio/dio.dart';
import 'package:my_music/features/home/data/models/album_model.dart';
import 'package:my_music/features/home/data/models/artist_model.dart';
import 'package:my_music/features/home/data/models/track_model.dart';

abstract class GenreDetailsRemoteDataSource {
  Future<List<TrackModel>> searchTracksByGenre(String genreName);
  Future<List<ArtistModel>> searchArtistsByGenre(String genreName);
  Future<List<AlbumModel>> searchAlbumsByGenre(String genreName);
}

class GenreDetailsRemoteDataSourceImpl implements GenreDetailsRemoteDataSource {
  final Dio dio;
  GenreDetailsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TrackModel>> searchTracksByGenre(String genreName) async {
    final response = await dio
        .get('/search/track', queryParameters: {'q': 'genre:"$genreName"'});
    return (response.data['data'] as List)
        .map((item) => TrackModel.fromJson(item))
        .toList();
  }

  @override
  Future<List<ArtistModel>> searchArtistsByGenre(String genreName) async {
    final response = await dio
        .get('/search/artist', queryParameters: {'q': 'genre:"$genreName"'});
    return (response.data['data'] as List)
        .map((item) => ArtistModel.fromJson(item))
        .toList();
  }

  @override
  Future<List<AlbumModel>> searchAlbumsByGenre(String genreName) async {
    final response = await dio
        .get('/search/album', queryParameters: {'q': 'genre:"$genreName"'});
    return (response.data['data'] as List)
        .map((item) => AlbumModel.fromJson(item))
        .toList();
  }
}