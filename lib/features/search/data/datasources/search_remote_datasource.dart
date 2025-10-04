import 'package:dio/dio.dart';
import 'package:my_music/features/home/data/models/album_model.dart';
import 'package:my_music/features/home/data/models/artist_model.dart';
import 'package:my_music/features/home/data/models/track_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<TrackModel>> searchTracks(String query);
  Future<List<ArtistModel>> searchArtists(String query);
  Future<List<AlbumModel>> searchAlbums(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;
  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TrackModel>> searchTracks(String query) async {
    final response = await dio.get('/search/track', queryParameters: {'q': query});
    return (response.data['data'] as List)
        .map((item) => TrackModel.fromJson(item))
        .toList();
  }

  @override
  Future<List<ArtistModel>> searchArtists(String query) async {
    final response =
    await dio.get('/search/artist', queryParameters: {'q': query});
    return (response.data['data'] as List)
        .map((item) => ArtistModel.fromJson(item))
        .toList();
  }

  @override
  Future<List<AlbumModel>> searchAlbums(String query) async {
    final response =
    await dio.get('/search/album', queryParameters: {'q': query});
    return (response.data['data'] as List)
        .map((item) => AlbumModel.fromJson(item))
        .toList();
  }
}