import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/presentation/widgets/artist_circle.dart';
import '../viewmodels/library_viewmodel.dart';

class ArtistsTab extends ConsumerWidget {
  final String searchQuery;
  const ArtistsTab({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryState = ref.watch(libraryViewModelProvider);
    return libraryState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (data) {
        final filteredArtists = data.libraryArtists
            .where((artist) =>
            artist.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

        if (filteredArtists.isEmpty) {
          return Center(
            child: Text(searchQuery.isEmpty
                ? 'Los artistas de tus canciones guardadas aparecerán aquí.'
                : 'No se encontraron artistas.'),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: filteredArtists.length,
          itemBuilder: (context, index) {
            return ArtistCircle(artist: filteredArtists[index]);
          },
        );
      },
    );
  }
}