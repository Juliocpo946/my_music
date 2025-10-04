import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/player/presentation/viewmodels/player_viewmodel.dart';
import '../../domain/entities/track.dart';

class SongListItem extends ConsumerWidget {
  final Track track;
  const SongListItem({super.key, required this.track});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: CachedNetworkImage(
          imageUrl: track.albumCover,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey[850]),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
      title: Text(track.title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(track.artist.name,
          style: Theme.of(context).textTheme.bodyMedium),
      onTap: () {
        ref.read(playerViewModelProvider.notifier).playTrack(track);
      },
    );
  }
}