import '../entities/album_details.dart';
import '../repositories/album_details_repository.dart';

class GetAlbumDetails {
  final AlbumDetailsRepository repository;

  GetAlbumDetails(this.repository);

  Future<AlbumDetails> call(int albumId) async {
    return await repository.getAlbumDetails(albumId);
  }
}