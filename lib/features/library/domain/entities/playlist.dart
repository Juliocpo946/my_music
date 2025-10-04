import 'package:equatable/equatable.dart';

class Playlist extends Equatable {
  final int id;
  final String name;
  final int trackCount;

  const Playlist({
    required this.id,
    required this.name,
    required this.trackCount,
  });

  @override
  List<Object?> get props => [id];
}