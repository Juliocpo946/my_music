import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/presentation/widgets/album_card.dart';
import '../viewmodels/library_viewmodel.dart';

class AlbumsTab extends ConsumerWidget {
  final String searchQuery;
  const AlbumsTab({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryState = ref.watch(libraryViewModelProvider);
    return libraryState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (data) {
        final filteredAlbums = data.libraryAlbums.where((album) {
          final query = searchQuery.toLowerCase();
          return album.title.toLowerCase().contains(query) ||
              album.artistName.toLowerCase().contains(query);
        }).toList();

        if (filteredAlbums.isEmpty) {
          return Center(
            child: Text(searchQuery.isEmpty
                ? 'Los álbumes de tus canciones guardadas aparecerán aquí.'
                : 'No se encontraron álbumes.'),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: filteredAlbums.length,
          itemBuilder: (context, index) {
            return AlbumCard(album: filteredAlbums[index]);
          },
        );
      },
    );
  }
}