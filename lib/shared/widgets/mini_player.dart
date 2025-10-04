import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_music/features/player/presentation/viewmodels/player_viewmodel.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerViewModelProvider);
    final playerNotifier = ref.read(playerViewModelProvider.notifier);
    final currentTrack = playerState.currentTrack;

    if (currentTrack == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => context.push('/player'),
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          border: Border(
            top: BorderSide(color: Colors.black.withAlpha(128), width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: currentTrack.albumCover,
                width: 48,
                height: 48,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentTrack.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    currentTrack.artist.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: playerNotifier.previousTrack,
            ),
            IconButton(
              icon: Icon(
                playerState.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                if (playerState.isPlaying) {
                  playerNotifier.pause();
                } else {
                  playerNotifier.resume();
                }
              },
              iconSize: 32,
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: playerNotifier.nextTrack,
            ),
          ],
        ),
      ),
    );
  }
}