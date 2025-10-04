import '../../domain/entities/playlist_details.dart';
import '../../domain/repositories/playlist_details_repository.dart';
import '../datasources/playlist_details_local_datasource.dart';

class PlaylistDetailsRepositoryImpl implements PlaylistDetailsRepository {
  final PlaylistDetailsLocalDataSource localDataSource;

  PlaylistDetailsRepositoryImpl({required this.localDataSource});

  @override
  Future<PlaylistDetails> getPlaylistDetails(int playlistId) async {
    final playlistInfo = await localDataSource.getPlaylistInfo(playlistId);
    final tracks = await localDataSource.getTracksForPlaylist(playlistId);
    return PlaylistDetails(playlist: playlistInfo, tracks: tracks);
  }
}