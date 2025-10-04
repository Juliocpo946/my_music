import 'package:dio/dio.dart';
import 'package:my_music/features/home/data/models/album_model.dart';
import 'package:my_music/features/home/data/models/artist_model.dart';
import 'package:my_music/features/home/data/models/track_model.dart';

abstract class ArtistDetailsRemoteDataSource {
  Future<ArtistModel> getArtistInfo(int artistId);
  Future<List<TrackModel>> getArtistTopTracks(int artistId);
  Future<List<AlbumModel>> getArtistAlbums(int artistId);
}

class ArtistDetailsRemoteDataSourceImpl implements ArtistDetailsRemoteDataSource {
  final Dio dio;
  ArtistDetailsRemoteDataSourceImpl({required this.dio});

  @override
  Future<ArtistModel> getArtistInfo(int artistId) async {
    final response = await dio.get('/artist/$artistId');
    return ArtistModel.fromJson(response.data);
  }

  @override
  Future<List<TrackModel>> getArtistTopTracks(int artistId) async {
    final response = await dio.get('/artist/$artistId/top?limit=5');
    return (response.data['data'] as List)
        .map((item) => TrackModel.fromJson(item))
        .toList();
  }

  @override
  Future<List<AlbumModel>> getArtistAlbums(int artistId) async {
    final response = await dio.get('/artist/$artistId/albums');
    return (response.data['data'] as List)
        .map((item) => AlbumModel.fromJson(item))
        .toList();
  }
}