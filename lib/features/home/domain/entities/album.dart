import 'package:equatable/equatable.dart';

class Album extends Equatable {
  final int id;
  final String title;
  final String coverMedium;
  final String artistName;

  const Album({
    required this.id,
    required this.title,
    required this.coverMedium,
    required this.artistName,
  });

  @override
  List<Object?> get props => [id];
}