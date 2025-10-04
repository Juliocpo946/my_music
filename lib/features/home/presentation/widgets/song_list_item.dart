import 'package:flutter/material.dart';
import '../../domain/entities/track.dart';

class SongListItem extends StatelessWidget {
  final Track track;
  const SongListItem({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Image.network(track.albumCover,
            width: 50, height: 50, fit: BoxFit.cover),
      ),
      title: Text(track.title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(track.artist.name,
          style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}