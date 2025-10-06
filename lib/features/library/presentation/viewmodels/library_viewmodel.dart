import 'package:my_music/features/home/domain/entities/artist.dart';
import 'package:my_music/features/library/domain/services/metadata_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_music/features/home/domain/entities/album.dart';
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
  final MetadataService _metadataService = MetadataService();

  @override
  Future<LibraryState> build() async {
    final initialState = await _loadData();
    return _sortAllData(initialState);
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

  Future<void> scanLocalFiles() async {
    var status = await Permission.audio.request();
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      state = AsyncData(state.value!.copyWith(isScanning: true));

      final List<Map<dynamic, dynamic>> nativeSongs = await _metadataService.scanLocalSongs();
      if (nativeSongs.isNotEmpty) {
        await _repository.clearLocalSongs();
      }

      final List<Track> foundTracks = [];
      for (var songMap in nativeSongs) {
        final filePath = songMap['filePath'] as String?;
        if (filePath == null) continue;

        foundTracks.add(Track(
          id: (songMap['id'] as int?)?.toInt() ?? filePath.hashCode,
          title: songMap['title'] ?? filePath.split('/').last,
          artist: Artist(
            id: (songMap['artist'] as String? ?? 'Artista Desconocido').hashCode,
            name: songMap['artist'] ?? 'Artista Desconocido',
            pictureMedium: '',
          ),
          albumId: (songMap['album'] as String? ?? 'Álbum Desconocido').hashCode,
          albumTitle: songMap['album'] ?? 'Álbum Desconocido',
          albumCover: '',
          duration: (songMap['duration'] as int?) ?? 0,
          preview: filePath,
          isLocal: true,
          filePath: filePath,
        ));
      }

      if (foundTracks.isNotEmpty) {
        await _repository.addMultipleTracksToLibrary(foundTracks);
      }

      ref.invalidateSelf();
      await future;
      state = AsyncData(state.value!.copyWith(isScanning: false));
    }
  }

  void sortTracks(TrackSortBy sortBy, SortOrder sortOrder) {
    if (state.value == null) return;
    state = AsyncData(_sortAllData(
        state.value!.copyWith(trackSortBy: sortBy, trackSortOrder: sortOrder)));
  }

  void sortAlbums(AlbumSortBy sortBy, SortOrder sortOrder) {
    if (state.value == null) return;
    state = AsyncData(_sortAllData(
        state.value!.copyWith(albumSortBy: sortBy, albumSortOrder: sortOrder)));
  }

  LibraryState _sortAllData(LibraryState currentState) {
    final tracks = List<Track>.from(currentState.libraryTracks);
    final albums = List<Album>.from(currentState.libraryAlbums);

    tracks.sort((a, b) {
      int comparison;
      if (currentState.trackSortBy == TrackSortBy.name) {
        comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
      } else {
        comparison = b.id.compareTo(a.id);
      }
      return currentState.trackSortOrder == SortOrder.asc
          ? comparison
          : -comparison;
    });

    albums.sort((a, b) {
      int comparison;
      if (currentState.albumSortBy == AlbumSortBy.albumName) {
        comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
      } else {
        comparison =
            a.artistName.toLowerCase().compareTo(b.artistName.toLowerCase());
      }
      return currentState.albumSortOrder == SortOrder.asc
          ? comparison
          : -comparison;
    });

    return currentState.copyWith(libraryTracks: tracks, libraryAlbums: albums);
  }

  Future<void> addTrackToPlaylist(int playlistId, Track track) async {
    await _repository.addTrackToPlaylist(playlistId, track);
    ref.invalidateSelf();
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
    if (!track.isLocal) {
      await _repository.addTrackToLibrary(track);
    }
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

  Future<void> deletePlaylist(int playlistId) async {
    await _repository.deletePlaylist(playlistId);
    ref.invalidateSelf();
  }
}