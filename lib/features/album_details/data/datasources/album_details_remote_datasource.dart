import 'package:dio/dio.dart';
import '../models/album_details_model.dart';

abstract class AlbumDetailsRemoteDataSource {
  Future<AlbumDetailsModel> getAlbumDetails(int albumId);
}

class AlbumDetailsRemoteDataSourceImpl implements AlbumDetailsRemoteDataSource {
  final Dio dio;
  AlbumDetailsRemoteDataSourceImpl({required this.dio});

  @override
  Future<AlbumDetailsModel> getAlbumDetails(int albumId) async {
    final response = await dio.get('/album/$albumId');
    return AlbumDetailsModel.fromJson(response.data);
  }
}