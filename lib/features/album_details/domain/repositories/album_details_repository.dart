import '../entities/album_details.dart';

abstract class AlbumDetailsRepository {
  Future<AlbumDetails> getAlbumDetails(int albumId);
}