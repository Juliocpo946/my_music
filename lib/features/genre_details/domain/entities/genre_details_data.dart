import 'package:my_music/features/home/domain/entities/album.dart';
import 'package:my_music/features/home/domain/entities/artist.dart';
import 'package:my_music/features/home/domain/entities/track.dart';

class GenreDetailsData {
  final List<Track> tracks;
  final List<Artist> artists;
  final List<Album> albums;

  GenreDetailsData({
    required this.tracks,
    required this.artists,
    required this.albums,
  });
}