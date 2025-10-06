import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_music/features/library/presentation/viewmodels/library_viewmodel.dart';
import 'package:my_music/features/player/presentation/providers/lyrics_provider.dart';
import 'package:my_music/features/player/presentation/viewmodels/player_viewmodel.dart';
import 'package:my_music/shared/widgets/add_to_playlist_dialog.dart';
import 'package:my_music/shared/widgets/track_options_menu.dart';

class PlayerPage extends ConsumerStatefulWidget {
  const PlayerPage({super.key});

  @override
  ConsumerState<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends ConsumerState<PlayerPage> {
  bool _showAlbumArt = true;
  bool _showLyrics = false;

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerViewModelProvider);
    final playerNotifier = ref.read(playerViewModelProvider.notifier);
    final libraryNotifier = ref.read(libraryViewModelProvider.notifier);
    final libraryStateAsync = ref.watch(libraryViewModelProvider);
    final track = playerState.currentTrack;
    final accentColor = Theme.of(context).primaryColor;

    if (track == null) {
      return const Scaffold(
        body: Center(child: Text('No hay ninguna canción seleccionada')),
      );
    }

    Widget buildPlaceholderArt() {
      return ClipRRect(
        key: const ValueKey('placeholderArt'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: MediaQuery.of(context).size.width - 48,
          height: MediaQuery.of(context).size.width - 48,
          color: accentColor,
          child: const Icon(Icons.music_note, color: Colors.white, size: 150),
        ),
      );
    }

    Widget buildAlbumArt() {
      return ClipRRect(
        key: const ValueKey('albumArt'),
        borderRadius: BorderRadius.circular(16),
        child: track.isLocal
            ? buildPlaceholderArt()
            : CachedNetworkImage(
          imageUrl: track.albumCover.replaceAll('250x250', '500x500'),
          width: MediaQuery.of(context).size.width - 48,
          height: MediaQuery.of(context).size.width - 48,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => buildPlaceholderArt(),
        ),
      );
    }

    Widget buildLyricsView() {
      final lyricsAsync = ref.watch(lyricsProvider(
        artist: track.artist.name,
        track: track.title,
      ));
      return Container(
        width: MediaQuery.of(context).size.width - 48,
        height: MediaQuery.of(context).size.width - 48,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: lyricsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) =>
          const Center(child: Text("Error al cargar la letra.")),
          data: (lyrics) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              lyrics,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontSize: 16, height: 1.5),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.expand_more, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            Text(
              'REPRODUCIENDO DESDE ÁLBUM',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Colors.white70),
            ),
            Text(track.albumTitle,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => TrackOptionsMenu(track: track),
              );
            },
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_showAlbumArt && !_showLyrics && !track.isLocal)
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
          Container(color: Colors.black.withOpacity(0.5)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _showLyrics
                        ? buildLyricsView()
                        : GestureDetector(
                      onTap: () =>
                          setState(() => _showAlbumArt = !_showAlbumArt),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _showAlbumArt
                            ? buildAlbumArt()
                            : buildPlaceholderArt(),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ToggleButtons(
                    isSelected: [_showLyrics == false, _showLyrics == true],
                    onPressed: (index) {
                      setState(() {
                        _showLyrics = index == 1;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    borderColor: Colors.white38,
                    selectedBorderColor: accentColor,
                    selectedColor: Colors.black,
                    fillColor: accentColor,
                    color: Colors.white,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Portada'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Letra'),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    key: const ValueKey('playerControls'),
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
                                        ? accentColor
                                        : Colors.white,
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
                                    iconSize: 28),
                                error: (_, __) => const IconButton(
                                    icon: Icon(Icons.error),
                                    onPressed: null,
                                    iconSize: 28),
                              ),
                              IconButton(
                                icon: const Icon(Icons.playlist_add),
                                color: Colors.white,
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (_) =>
                                        AddToPlaylistDialog(track: track),
                                  );
                                },
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
                        baseBarColor: Colors.white.withOpacity(0.24),
                        progressBarColor: accentColor,
                        thumbColor: accentColor,
                        timeLabelTextStyle: const TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.shuffle, color: accentColor),
                            onPressed: playerNotifier.toggleShuffle,
                            iconSize: 28,
                          ),
                          IconButton(
                            icon:
                            Icon(Icons.skip_previous, color: accentColor),
                            onPressed: playerNotifier.previousTrack,
                            iconSize: 40,
                          ),
                          GestureDetector(
                            onTap: playerState.isPlaying
                                ? playerNotifier.pause
                                : playerNotifier.resume,
                            onLongPress: (){},
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              child: Icon(
                                playerState.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 45,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.skip_next, color: accentColor),
                            onPressed: playerNotifier.nextTrack,
                            iconSize: 40,
                          ),
                          IconButton(
                            icon: Icon(Icons.repeat, color: accentColor),
                            onPressed: playerNotifier.toggleLoopMode,
                            iconSize: 28,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.replay_10, color: Colors.white),
                            onPressed: playerNotifier.rewind,
                          ),
                          IconButton(
                            icon: const Icon(Icons.forward_10, color: Colors.white),
                            onPressed: playerNotifier.forward,
                          ),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}