import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/library/presentation/viewmodels/library_viewmodel.dart';
import '../viewmodels/album_details_viewmodel.dart';
import '../widgets/track_list_item.dart';

class AlbumDetailsPage extends ConsumerWidget {
  final int albumId;
  final String? localAlbumTitle;

  const AlbumDetailsPage({
    super.key,
    required this.albumId,
    this.localAlbumTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumDetailsAsync = ref.watch(albumDetailsViewModelProvider(
      albumId: albumId,
      localAlbumTitle: localAlbumTitle,
    ));
    final libraryNotifier = ref.read(libraryViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Álbum'),
      ),
      body: albumDetailsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(
            child: Text('No se pudo cargar la información del álbum.')),
        data: (details) {
          final allTracks = [...details.localTracks, ...details.tracks];
          final representativeTrack = allTracks.isNotEmpty ? allTracks.first : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: Builder(
                      builder: (context) {
                        if (details.coverBig.isNotEmpty) {
                          return CachedNetworkImage(
                            imageUrl: details.coverBig,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                              child: const Icon(Icons.music_note,
                                  color: Colors.white, size: 100),
                            ),
                          );
                        } else if (representativeTrack?.embeddedPicture !=
                            null) {
                          return Image.memory(
                            representativeTrack!.embeddedPicture as Uint8List,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Container(
                            color:
                            Theme.of(context).primaryColor.withOpacity(0.3),
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 100,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  details.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                if (details.title == 'Álbum Desconocido')
                  Text(
                    '(Desconocido)',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                Text(
                  details.artistName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                if (details.tracks.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () {
                      libraryNotifier.addAlbumToLibrary(details.tracks);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Álbum añadido a Canciones')),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar a Canciones'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                if (details.localTracks.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('En tu biblioteca',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  const Divider(height: 24),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: details.localTracks.length,
                    itemBuilder: (context, index) {
                      final track = details.localTracks[index];
                      return TrackListItem(
                        track: track,
                        cover:
                        details.coverBig.replaceAll('1000x1000', '250x250'),
                        albumId: details.id,
                        albumTitle: details.title,
                        queue: allTracks,
                      );
                    },
                  ),
                ],
                if (details.tracks.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Canciones del álbum',
                        style: Theme.of(context).textTheme.headlineMedium),
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
                        queue: allTracks,
                      );
                    },
                  ),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}