import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/library/presentation/viewmodels/library_viewmodel.dart';
import '../viewmodels/album_details_viewmodel.dart';
import '../widgets/track_list_item.dart';

class AlbumDetailsPage extends ConsumerWidget {
  final int albumId;
  const AlbumDetailsPage({super.key, required this.albumId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumDetailsAsync = ref.watch(albumDetailsViewModelProvider(albumId));
    final libraryNotifier = ref.read(libraryViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Álbum'),
      ),
      body: albumDetailsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (details) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: details.coverBig,
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  details.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  details.artistName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    libraryNotifier.addAlbumToLibrary(details.tracks);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Álbum añadido a Canciones')),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar a Canciones'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
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
                  itemCount: details.tracks.length,
                  itemBuilder: (context, index) {
                    final track = details.tracks[index];
                    return TrackListItem(
                      track: track,
                      cover:
                      details.coverBig.replaceAll('1000x1000', '250x250'),
                      albumId: details.id,
                      albumTitle: details.title,
                    );
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