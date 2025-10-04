import 'package:my_music/features/home/domain/entities/album.dart';
import 'package:my_music/features/home/domain/entities/artist.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/repositories/library_repository.dart';
import '../datasources/library_local_datasource.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryLocalDataSource localDataSource;

  LibraryRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addTrackToLibrary(Track track) =>
      localDataSource.addTrackToLibrary(track);

  @override
  Future<void> addMultipleTracksToLibrary(List<Track> tracks) =>
      localDataSource.addMultipleTracksToLibrary(tracks);

  @override
  Future<void> removeTrackFromLibrary(int trackId) =>
      localDataSource.removeTrackFromLibrary(trackId);

  @override
  Future<List<Track>> getLibraryTracks() => localDataSource.getLibraryTracks();

  @override
  Future<bool> isInLibrary(int trackId) => localDataSource.isInLibrary(trackId);

  @override
  Future<void> addFavorite(int trackId) => localDataSource.addFavorite(trackId);

  @override
  Future<void> removeFavorite(int trackId) =>
      localDataSource.removeFavorite(trackId);

  @override
  Future<List<int>> getFavoriteTrackIds() =>
      localDataSource.getFavoriteTrackIds();

  @override
  Future<bool> isFavorite(int trackId) => localDataSource.isFavorite(trackId);

  @override
  Future<List<Playlist>> getPlaylists() => localDataSource.getPlaylists();

  @override
  Future<List<Album>> getLibraryAlbums() => localDataSource.getLibraryAlbums();

  @override
  Future<List<Artist>> getLibraryArtists() =>
      localDataSource.getLibraryArtists();

  @override
  Future<void> createPlaylist(String name) =>
      localDataSource.createPlaylist(name);
}