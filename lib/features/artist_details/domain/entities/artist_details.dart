import 'package:equatable/equatable.dart';
import 'package:my_music/features/home/domain/entities/album.dart';
import 'package:my_music/features/home/domain/entities/artist.dart';
import 'package:my_music/features/home/domain/entities/track.dart';

class ArtistDetails extends Equatable {
  final Artist artist;
  final List<Track> topTracks;
  final List<Album> albums;

  const ArtistDetails({
    required this.artist,
    required this.topTracks,
    required this.albums,
  });

  @override
  List<Object?> get props => [artist.id];
}