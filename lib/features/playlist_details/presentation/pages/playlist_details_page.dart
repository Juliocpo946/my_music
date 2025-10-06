import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/presentation/widgets/song_list_item.dart';
import '../viewmodels/playlist_details_viewmodel.dart';

class PlaylistDetailsPage extends ConsumerWidget {
  final int playlistId;
  const PlaylistDetailsPage({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistDetailsAsync =
    ref.watch(playlistDetailsViewModelProvider(playlistId));

    return Scaffold(
      body: playlistDetailsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (details) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(details.playlist.name),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Colors.black
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.music_note,
                      size: 100,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
              if (details.tracks.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(48.0),
                    child: Center(
                      child: Text('Añade canciones a esta playlist'),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return SongListItem(
                          track: details.tracks[index],
                          queue: details.tracks);
                    },
                    childCount: details.tracks.length,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}