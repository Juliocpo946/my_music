import 'package:dio/dio.dart';
import '../models/album_model.dart';
import '../models/artist_model.dart';
import '../models/track_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<AlbumModel>> getNewReleases();
  Future<List<TrackModel>> getTopTracks();
  Future<List<ArtistModel>> getTopArtists();
  Future<List<String>> getGenres();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;
  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<AlbumModel>> getNewReleases() async {
    final response = await dio.get('/editorial/0/releases');
    return (response.data['data'] as List)
        .map((item) => AlbumModel.fromJson(item))
        .toList();
  }

  @override
  Future<List<TrackModel>> getTopTracks() async {
    final response = await dio.get('/chart/0/tracks');
    return (response.data['data'] as List)
        .map((item) => TrackModel.fromJson(item))
        .toList();
  }

  @override
  Future<List<ArtistModel>> getTopArtists() async {
    final response = await dio.get('/chart/0/artists');
    return (response.data['data'] as List)
        .map((item) => ArtistModel.fromJson(item))
        .toList();
  }

  @override
  Future<List<String>> getGenres() async {
    final response = await dio.get('/genre');
    return (response.data['data'] as List)
        .map((item) => item['name'] as String)
        .toList();
  }
}