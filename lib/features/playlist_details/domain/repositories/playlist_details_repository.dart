import '../entities/playlist_details.dart';

abstract class PlaylistDetailsRepository {
  Future<PlaylistDetails> getPlaylistDetails(int playlistId);
}