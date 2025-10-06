import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/player/presentation/viewmodels/player_viewmodel.dart';
import 'package:my_music/shared/widgets/track_options_menu.dart';
import '../../domain/entities/track.dart';

class SongListItem extends ConsumerWidget {
  final Track track;
  final List<Track>? queue;

  const SongListItem({super.key, required this.track, this.queue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerViewModelProvider);
    final isPlayingThisTrack =
        playerState.isPlaying && playerState.currentTrack?.id == track.id;

    Widget imageWidget;
    if (track.isLocal && track.embeddedPicture != null) {
      imageWidget = Image.memory(
        track.embeddedPicture as Uint8List,
        fit: BoxFit.cover,
        width: 50,
        height: 50,
      );
    } else if (!track.isLocal && track.albumCover.isNotEmpty) {
      imageWidget = CachedNetworkImage(
        imageUrl: track.albumCover,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: Colors.grey[850]),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      imageWidget = Container(
        width: 50,
        height: 50,
        color: Theme.of(context).primaryColor.withOpacity(0.3),
        child: const Icon(Icons.music_note, color: Colors.white),
      );
    }

    return ListTile(
      tileColor: isPlayingThisTrack
          ? Theme.of(context).primaryColor.withOpacity(0.25)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: imageWidget,
      ),
      title: Text(track.title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle:
      Text(track.artist.name, style: Theme.of(context).textTheme.bodyMedium),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => TrackOptionsMenu(track: track),
          );
        },
      ),
      onTap: () {
        ref.read(playerViewModelProvider.notifier).playTrack(track, queue: queue);
      },
    );
  }
}