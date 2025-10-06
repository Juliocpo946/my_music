import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/presentation/widgets/song_list_item.dart';
import 'package:my_music/features/library/presentation/viewmodels/library_viewmodel.dart';
import 'dart:typed_data';

class LocalAlbumDetailsPage extends ConsumerWidget {
  final int albumId;
  final String albumTitle;

  const LocalAlbumDetailsPage({
    super.key,
    required this.albumId,
    required this.albumTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryAsync = ref.watch(libraryViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(albumTitle),
      ),
      body: libraryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (libraryState) {
          final tracks = libraryState.libraryTracks
              .where((track) => track.isLocal && track.albumId == albumId)
              .toList();

          if (tracks.isEmpty) {
            return const Center(
              child: Text('No se encontraron canciones para este álbum.'),
            );
          }

          final representativeTrack = tracks.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: representativeTrack.embeddedPicture != null
                      ? Image.memory(
                    representativeTrack.embeddedPicture as Uint8List,
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    height: 250,
                    width: 250,
                    color:
                    Theme.of(context).primaryColor.withOpacity(0.3),
                    child: const Icon(Icons.music_note,
                        color: Colors.white, size: 100),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  albumTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  representativeTrack.artist.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Canciones',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const Divider(height: 24),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tracks.length,
                  itemBuilder: (context, index) {
                    return SongListItem(track: tracks[index]);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}