import 'package:equatable/equatable.dart';
import 'package:my_music/features/home/domain/entities/album.dart';
import 'package:my_music/features/home/domain/entities/artist.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import 'package:my_music/features/library/domain/entities/playlist.dart';

enum SortOrder { asc, desc }
enum TrackSortBy { name, dateAdded }
enum AlbumSortBy { albumName, artistName }

class LibraryState extends Equatable {
  final List<Playlist> playlists;
  final List<Track> libraryTracks;
  final List<int> favoriteTrackIds;
  final List<Album> libraryAlbums;
  final List<Artist> libraryArtists;
  final bool isScanning;
  final TrackSortBy trackSortBy;
  final AlbumSortBy albumSortBy;
  final SortOrder trackSortOrder;
  final SortOrder albumSortOrder;

  const LibraryState({
    this.playlists = const [],
    this.libraryTracks = const [],
    this.favoriteTrackIds = const [],
    this.libraryAlbums = const [],
    this.libraryArtists = const [],
    this.isScanning = false,
    this.trackSortBy = TrackSortBy.dateAdded,
    this.albumSortBy = AlbumSortBy.albumName,
    this.trackSortOrder = SortOrder.asc,
    this.albumSortOrder = SortOrder.asc,
  });

  LibraryState copyWith({
    List<Playlist>? playlists,
    List<Track>? libraryTracks,
    List<int>? favoriteTrackIds,
    List<Album>? libraryAlbums,
    List<Artist>? libraryArtists,
    bool? isScanning,
    TrackSortBy? trackSortBy,
    AlbumSortBy? albumSortBy,
    SortOrder? trackSortOrder,
    SortOrder? albumSortOrder,
  }) {
    return LibraryState(
      playlists: playlists ?? this.playlists,
      libraryTracks: libraryTracks ?? this.libraryTracks,
      favoriteTrackIds: favoriteTrackIds ?? this.favoriteTrackIds,
      libraryAlbums: libraryAlbums ?? this.libraryAlbums,
      libraryArtists: libraryArtists ?? this.libraryArtists,
      isScanning: isScanning ?? this.isScanning,
      trackSortBy: trackSortBy ?? this.trackSortBy,
      albumSortBy: albumSortBy ?? this.albumSortBy,
      trackSortOrder: trackSortOrder ?? this.trackSortOrder,
      albumSortOrder: albumSortOrder ?? this.albumSortOrder,
    );
  }

  @override
  List<Object?> get props => [
    playlists,
    libraryTracks,
    favoriteTrackIds,
    libraryAlbums,
    libraryArtists,
    isScanning,
    trackSortBy,
    albumSortBy,
    trackSortOrder,
    albumSortOrder
  ];
}