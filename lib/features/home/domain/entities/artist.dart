import 'package:equatable/equatable.dart';

class Artist extends Equatable {
  final int id;
  final String name;
  final String pictureMedium;

  const Artist({
    required this.id,
    required this.name,
    required this.pictureMedium,
  });

  @override
  List<Object?> get props => [id];
}