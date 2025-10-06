import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/presentation/widgets/song_list_item.dart';
import '../viewmodels/library_viewmodel.dart';
import '../viewmodels/library_state.dart';

class LibrarySongsTab extends ConsumerWidget {
  final String searchQuery;
  const LibrarySongsTab({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryState = ref.watch(libraryViewModelProvider);
    final libraryNotifier = ref.read(libraryViewModelProvider.notifier);

    return libraryState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (data) {
        final filteredTracks = data.libraryTracks.where((track) {
          final query = searchQuery.toLowerCase();
          return track.title.toLowerCase().contains(query) ||
              track.artist.name.toLowerCase().contains(query);
        }).toList();

        if (filteredTracks.isEmpty) {
          return Center(
            child: Text(searchQuery.isEmpty
                ? 'Agrega canciones a tu biblioteca.'
                : 'No se encontraron canciones.'),
          );
        }
        return Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    '${filteredTracks.length} ${filteredTracks.length == 1 ? "canción" : "canciones"}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  PopupMenuButton<TrackSortBy>(
                    initialValue: data.trackSortBy,
                    onSelected: (sortBy) {
                      libraryNotifier.sortTracks(sortBy, data.trackSortOrder);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: TrackSortBy.name,
                          child: Text('Ordenar por Nombre')),
                      const PopupMenuItem(
                          value: TrackSortBy.dateAdded,
                          child: Text('Ordenar por Fecha')),
                    ],
                    child: const Icon(Icons.sort),
                  ),
                  IconButton(
                    icon: Icon(data.trackSortOrder == SortOrder.asc
                        ? Icons.arrow_upward
                        : Icons.arrow_downward),
                    onPressed: () {
                      final newOrder = data.trackSortOrder == SortOrder.asc
                          ? SortOrder.desc
                          : SortOrder.asc;
                      libraryNotifier.sortTracks(data.trackSortBy, newOrder);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTracks.length,
                itemBuilder: (context, index) {
                  return SongListItem(
                      track: filteredTracks[index], queue: filteredTracks);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}