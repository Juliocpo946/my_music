import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_music/features/home/domain/entities/album.dart';
import 'package:my_music/features/home/domain/entities/artist.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import 'package:my_music/features/library/domain/entities/playlist.dart';
import '../../data/datasources/library_local_datasource.dart';
import '../../data/repositories/library_repository_impl.dart';
import 'library_state.dart';

part 'library_viewmodel.g.dart';

@riverpod
class LibraryViewModel extends _$LibraryViewModel {
  final LibraryRepositoryImpl _repository =
  LibraryRepositoryImpl(localDataSource: LibraryLocalDataSourceImpl());

  @override
  Future<LibraryState> build() async {
    return await _loadData();
  }

  Future<LibraryState> _loadData() async {
    final results = await Future.wait([
      _repository.getPlaylists(),
      _repository.getLibraryTracks(),
      _repository.getFavoriteTrackIds(),
      _repository.getLibraryAlbums(),
      _repository.getLibraryArtists(),
    ]);
    return LibraryState(
      playlists: results[0] as List<Playlist>,
      libraryTracks: results[1] as List<Track>,
      favoriteTrackIds: results[2] as List<int>,
      libraryAlbums: results[3] as List<Album>,
      libraryArtists: results[4] as List<Artist>,
    );
  }

  Future<void> addTrackToLibrary(Track track) async {
    await _repository.addTrackToLibrary(track);
    ref.invalidateSelf();
  }

  Future<void> addAlbumToLibrary(List<Track> tracks) async {
    await _repository.addMultipleTracksToLibrary(tracks);
    ref.invalidateSelf();
  }

  Future<void> removeTrackFromLibrary(int trackId) async {
    await _repository.removeTrackFromLibrary(trackId);
    await _repository.removeFavorite(trackId);
    ref.invalidateSelf();
  }

  Future<void> addFavorite(Track track) async {
    await _repository.addTrackToLibrary(track);
    await _repository.addFavorite(track.id);
    ref.invalidateSelf();
  }

  Future<void> removeFavorite(int trackId) async {
    await _repository.removeFavorite(trackId);
    ref.invalidateSelf();
  }

  Future<bool> isFavorite(int trackId) async {
    return _repository.isFavorite(trackId);
  }

  Future<bool> isInLibrary(int trackId) async {
    return _repository.isInLibrary(trackId);
  }

  Future<void> createPlaylist(String name) async {
    if (name.trim().isEmpty) return;
    await _repository.createPlaylist(name);
    ref.invalidateSelf();
  }
}