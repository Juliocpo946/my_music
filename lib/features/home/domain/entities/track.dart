import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'artist.dart';

class Track extends Equatable {
  final int id;
  final String title;
  final String preview;
  final Artist artist;
  final int albumId;
  final String albumTitle;
  final String albumCover;
  final int duration;
  final bool isLocal;
  final String? filePath;
  final Uint8List? embeddedPicture;

  const Track({
    required this.id,
    required this.title,
    required this.preview,
    required this.artist,
    required this.albumId,
    required this.albumTitle,
    required this.albumCover,
    required this.duration,
    this.isLocal = false,
    this.filePath,
    this.embeddedPicture,
  });

  @override
  List<Object?> get props => [id, isLocal, filePath];
}