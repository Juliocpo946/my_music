import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/library_viewmodel.dart';

class PlaylistsTab extends ConsumerWidget {
  final String searchQuery;
  const PlaylistsTab({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryState = ref.watch(libraryViewModelProvider);

    return libraryState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (data) {
        final filteredPlaylists = data.playlists
            .where((playlist) =>
            playlist.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

        if (filteredPlaylists.isEmpty) {
          return Center(
            child: Text(searchQuery.isEmpty
                ? 'Crea tu primera playlist'
                : 'No se encontraron playlists'),
          );
        }
        return ListView.builder(
          itemCount: filteredPlaylists.length,
          itemBuilder: (context, index) {
            final playlist = filteredPlaylists[index];
            return ListTile(
              leading: Container(
                width: 50,
                height: 50,
                color: Colors.grey.shade800,
                child: const Icon(Icons.music_note),
              ),
              title: Text(playlist.name),
              subtitle: Text('Playlist • ${playlist.trackCount} canciones'),
              onTap: () => context.push('/library/playlist/${playlist.id}'),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.share),
                          title: const Text('Compartir'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete_outline),
                          title: const Text('Eliminar playlist'),
                          onTap: () {
                            Navigator.pop(context);
                            ref
                                .read(libraryViewModelProvider.notifier)
                                .deletePlaylist(playlist.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}