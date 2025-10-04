import 'album.dart';
import 'artist.dart';
import 'track.dart';

class HomeData {
  String userName;
  final List<Album> newReleases;
  final List<Track> topTracks;
  final List<Artist> topArtists;
  final List<String> genres;
  List<Track> recommendations;

  HomeData({
    this.userName = '',
    required this.newReleases,
    required this.topTracks,
    required this.topArtists,
    required this.genres,
    this.recommendations = const [],
  });
}