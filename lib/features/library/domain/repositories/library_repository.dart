import 'package:my_music/features/home/domain/entities/album.dart';
import 'package:my_music/features/home/domain/entities/artist.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import '../entities/playlist.dart';

abstract class LibraryRepository {
  Future<void> addTrackToLibrary(Track track);
  Future<void> addMultipleTracksToLibrary(List<Track> tracks);
  Future<void> removeTrackFromLibrary(int trackId);
  Future<List<Track>> getLibraryTracks();
  Future<bool> isInLibrary(int trackId);

  Future<void> addFavorite(int trackId);
  Future<void> removeFavorite(int trackId);
  Future<List<int>> getFavoriteTrackIds();
  Future<bool> isFavorite(int trackId);

  Future<List<Playlist>> getPlaylists();
  Future<List<Album>> getLibraryAlbums();
  Future<List<Artist>> getLibraryArtists();
  Future<void> createPlaylist(String name);
  Future<void> addTrackToPlaylist(int playlistId, Track track);
  Future<void> deletePlaylist(int playlistId);
}