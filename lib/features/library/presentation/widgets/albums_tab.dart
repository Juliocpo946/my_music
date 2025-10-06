import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/presentation/widgets/album_card.dart';
import '../viewmodels/library_viewmodel.dart';
import '../viewmodels/library_state.dart';

class AlbumsTab extends ConsumerWidget {
  final String searchQuery;
  const AlbumsTab({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryState = ref.watch(libraryViewModelProvider);
    final libraryNotifier = ref.read(libraryViewModelProvider.notifier);

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
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    '${filteredAlbums.length} ${filteredAlbums.length == 1 ? "álbum" : "álbumes"}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  PopupMenuButton<AlbumSortBy>(
                    initialValue: data.albumSortBy,
                    onSelected: (sortBy) {
                      libraryNotifier.sortAlbums(sortBy, data.albumSortOrder);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: AlbumSortBy.albumName, child: Text('Ordenar por Álbum')),
                      const PopupMenuItem(value: AlbumSortBy.artistName, child: Text('Ordenar por Artista')),
                    ],
                    child: const Icon(Icons.sort),
                  ),
                  IconButton(
                    icon: Icon(data.albumSortOrder == SortOrder.asc ? Icons.arrow_upward : Icons.arrow_downward),
                    onPressed: () {
                      final newOrder = data.albumSortOrder == SortOrder.asc ? SortOrder.desc : SortOrder.asc;
                      libraryNotifier.sortAlbums(data.albumSortBy, newOrder);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              ),
            ),
          ],
        );
      },
    );
  }
}