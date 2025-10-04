import '../../domain/entities/album_details.dart';
import '../../domain/repositories/album_details_repository.dart';
import '../datasources/album_details_remote_datasource.dart';

class AlbumDetailsRepositoryImpl implements AlbumDetailsRepository {
  final AlbumDetailsRemoteDataSource remoteDataSource;

  AlbumDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AlbumDetails> getAlbumDetails(int albumId) async {
    try {
      final albumDetailsModel = await remoteDataSource.getAlbumDetails(albumId);
      return albumDetailsModel;
    } catch (e) {
      throw Exception('Failed to load album details');
    }
  }
}