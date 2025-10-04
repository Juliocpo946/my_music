import 'package:equatable/equatable.dart';
import 'package:my_music/features/home/domain/entities/album.dart';
import 'package:my_music/features/home/domain/entities/artist.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import 'package:my_music/features/library/domain/entities/playlist.dart';

class LibraryState extends Equatable {
  final List<Playlist> playlists;
  final List<Track> libraryTracks;
  final List<int> favoriteTrackIds;
  final List<Album> libraryAlbums;
  final List<Artist> libraryArtists;

  const LibraryState({
    this.playlists = const [],
    this.libraryTracks = const [],
    this.favoriteTrackIds = const [],
    this.libraryAlbums = const [],
    this.libraryArtists = const [],
  });

  LibraryState copyWith({
    List<Playlist>? playlists,
    List<Track>? libraryTracks,
    List<int>? favoriteTrackIds,
    List<Album>? libraryAlbums,
    List<Artist>? libraryArtists,
  }) {
    return LibraryState(
      playlists: playlists ?? this.playlists,
      libraryTracks: libraryTracks ?? this.libraryTracks,
      favoriteTrackIds: favoriteTrackIds ?? this.favoriteTrackIds,
      libraryAlbums: libraryAlbums ?? this.libraryAlbums,
      libraryArtists: libraryArtists ?? this.libraryArtists,
    );
  }

  @override
  List<Object?> get props => [
    playlists,
    libraryTracks,
    favoriteTrackIds,
    libraryAlbums,
    libraryArtists
  ];
}