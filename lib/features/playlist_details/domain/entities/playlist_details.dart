import 'package:my_music/features/home/domain/entities/track.dart';
import 'package:my_music/features/library/domain/entities/playlist.dart';

class PlaylistDetails {
  final Playlist playlist;
  final List<Track> tracks;

  PlaylistDetails({
    required this.playlist,
    required this.tracks,
  });
}