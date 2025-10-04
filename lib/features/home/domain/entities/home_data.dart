import 'album.dart';
import 'artist.dart';
import 'track.dart';

class HomeData {
  final List<Album> newReleases;
  final List<Track> topTracks;
  final List<Artist> topArtists;
  final List<String> genres;

  HomeData({
    required this.newReleases,
    required this.topTracks,
    required this.topArtists,
    required this.genres,
  });
}