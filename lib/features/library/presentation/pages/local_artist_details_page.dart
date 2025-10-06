import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/presentation/widgets/song_list_item.dart';
import 'package:my_music/features/library/presentation/viewmodels/library_viewmodel.dart';

class LocalArtistDetailsPage extends ConsumerWidget {
  final String artistName;

  const LocalArtistDetailsPage({super.key, required this.artistName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryAsync = ref.watch(libraryViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(artistName),
      ),
      body: libraryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (libraryState) {
          final tracks = libraryState.libraryTracks
              .where((track) => track.isLocal && track.artist.name == artistName)
              .toList();

          if (tracks.isEmpty) {
            return const Center(
              child: Text('No se encontraron canciones para este artista.'),
            );
          }

          return ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              return SongListItem(track: tracks[index]);
            },
          );
        },
      ),
    );
  }
}