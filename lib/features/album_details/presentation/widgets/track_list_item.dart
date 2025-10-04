import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import 'package:my_music/features/player/presentation/viewmodels/player_viewmodel.dart';
import 'package:my_music/shared/widgets/track_options_menu.dart';

class TrackListItem extends ConsumerWidget {
  final Track track;
  final String cover;
  final int albumId;
  final String albumTitle;

  const TrackListItem({
    super.key,
    required this.track,
    required this.cover,
    required this.albumId,
    required this.albumTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerNotifier = ref.read(playerViewModelProvider.notifier);
    final playerState = ref.watch(playerViewModelProvider);
    final isPlayingThisTrack =
        playerState.isPlaying && playerState.currentTrack?.id == track.id;

    String formatDuration(int seconds) {
      final duration = Duration(seconds: seconds);
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    }

    final trackToPlay = Track(
      id: track.id,
      title: track.title,
      preview: track.preview,
      artist: track.artist,
      albumCover: cover,
      duration: track.duration,
      albumId: albumId,
      albumTitle: albumTitle,
    );

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      tileColor: isPlayingThisTrack
          ? Theme.of(context).primaryColor.withOpacity(0.25)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(track.title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(
        formatDuration(track.duration),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => TrackOptionsMenu(track: trackToPlay),
          );
        },
      ),
      onTap: () {
        playerNotifier.playTrack(trackToPlay);
      },
    );
  }
}