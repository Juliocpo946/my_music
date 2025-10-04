import 'package:equatable/equatable.dart';
import 'package:my_music/features/home/domain/entities/track.dart';

class AlbumDetails extends Equatable {
  final int id;
  final String title;
  final String coverBig;
  final String artistName;
  final List<Track> tracks;

  const AlbumDetails({
    required this.id,
    required this.title,
    required this.coverBig,
    required this.artistName,
    required this.tracks,
  });

  @override
  List<Object?> get props => [id];
}