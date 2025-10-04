import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_music/features/library/presentation/viewmodels/library_viewmodel.dart';
import 'package:my_music/features/player/presentation/viewmodels/player_viewmodel.dart';

class PlayerPage extends ConsumerWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerViewModelProvider);
    final playerNotifier = ref.read(playerViewModelProvider.notifier);
    final libraryNotifier = ref.read(libraryViewModelProvider.notifier);
    final libraryStateAsync = ref.watch(libraryViewModelProvider);
    final track = playerState.currentTrack;

    if (track == null) {
      return const Scaffold(
        body: Center(child: Text('No hay ninguna canción seleccionada')),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.expand_more),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            Text(
              'PLAYING FROM ALBUM',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Colors.white.withAlpha(178)),
            ),
            Text(track.albumTitle,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Stack(
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(track.albumCover),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black.withAlpha(128),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox.shrink(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl:
                      track.albumCover.replaceAll('250x250', '500x500'),
                      width: MediaQuery.of(context).size.width - 48,
                      height: MediaQuery.of(context).size.width - 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(track.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                                Text(track.artist.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              libraryStateAsync.when(
                                data: (libraryState) {
                                  final isFavorite = libraryState
                                      .favoriteTrackIds
                                      .contains(track.id);
                                  return IconButton(
                                    icon: Icon(isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border),
                                    color: isFavorite
                                        ? Theme.of(context).primaryColor
                                        : null,
                                    onPressed: () {
                                      if (isFavorite) {
                                        libraryNotifier
                                            .removeFavorite(track.id);
                                      } else {
                                        libraryNotifier.addFavorite(track);
                                      }
                                    },
                                    iconSize: 28,
                                  );
                                },
                                loading: () => const IconButton(
                                  icon: Icon(Icons.favorite_border),
                                  onPressed: null,
                                  iconSize: 28,
                                ),
                                error: (_, __) => const IconButton(
                                  icon: Icon(Icons.error),
                                  onPressed: null,
                                  iconSize: 28,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.playlist_add),
                                onPressed: () {},
                                iconSize: 32,
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      ProgressBar(
                        progress: playerState.position,
                        total: playerState.duration,
                        onSeek: playerNotifier.seek,
                        baseBarColor: Colors.white.withAlpha(77),
                        progressBarColor: Colors.white,
                        thumbColor: Colors.white,
                        timeLabelTextStyle: const TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shuffle),
                            onPressed: () {},
                            iconSize: 28,
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_previous),
                            onPressed: playerNotifier.previousTrack,
                            iconSize: 40,
                          ),
                          GestureDetector(
                            onTap: playerState.isPlaying
                                ? playerNotifier.pause
                                : playerNotifier.resume,
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor:
                              Theme.of(context).colorScheme.primary,
                              child: Icon(
                                playerState.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            onPressed: playerNotifier.nextTrack,
                            iconSize: 40,
                          ),
                          IconButton(
                            icon: const Icon(Icons.repeat),
                            onPressed: () {},
                            iconSize: 28,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}