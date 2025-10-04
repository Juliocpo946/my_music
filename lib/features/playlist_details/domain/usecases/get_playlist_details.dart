import '../entities/playlist_details.dart';
import '../repositories/playlist_details_repository.dart';

class GetPlaylistDetails {
  final PlaylistDetailsRepository repository;

  GetPlaylistDetails(this.repository);

  Future<PlaylistDetails> call(int playlistId) {
    return repository.getPlaylistDetails(playlistId);
  }
}