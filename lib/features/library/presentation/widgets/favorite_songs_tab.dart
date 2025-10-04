import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/presentation/widgets/song_list_item.dart';
import '../viewmodels/library_viewmodel.dart';

class FavoriteSongsTab extends ConsumerWidget {
  final String searchQuery;
  const FavoriteSongsTab({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryState = ref.watch(libraryViewModelProvider);

    return libraryState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (data) {
        final favoriteTracks = data.libraryTracks
            .where((track) => data.favoriteTrackIds.contains(track.id))
            .toList();

        final filteredTracks = favoriteTracks.where((track) {
          final query = searchQuery.toLowerCase();
          return track.title.toLowerCase().contains(query) ||
              track.artist.name.toLowerCase().contains(query);
        }).toList();

        if (filteredTracks.isEmpty) {
          return Center(
            child: Text(searchQuery.isEmpty
                ? 'Tus canciones favoritas aparecerán aquí.'
                : 'No se encontraron canciones.'),
          );
        }
        return ListView.builder(
          itemCount: filteredTracks.length,
          itemBuilder: (context, index) {
            return SongListItem(track: filteredTracks[index]);
          },
        );
      },
    );
  }
}