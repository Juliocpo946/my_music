import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/player/presentation/viewmodels/player_viewmodel.dart';

class PlaybackQueueBottomSheet extends ConsumerWidget {
  const PlaybackQueueBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerViewModelProvider);
    final playerNotifier = ref.read(playerViewModelProvider.notifier);
    final queue = playerState.queue;
    final currentTrack = playerState.currentTrack;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'A continuación',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: queue.length,
                  itemBuilder: (context, index) {
                    final track = queue[index];
                    final bool isCurrent = track.id == currentTrack?.id;
                    return ListTile(
                      leading: Icon(
                        isCurrent ? Icons.volume_up : Icons.music_note,
                        color: isCurrent
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                      ),
                      title: Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isCurrent
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        track.artist.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        playerNotifier.playTrackFromQueue(track);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}