import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/presentation/widgets/album_card.dart';
import 'package:my_music/features/home/presentation/widgets/song_list_item.dart';
import '../viewmodels/artist_details_viewmodel.dart';

class ArtistDetailsPage extends ConsumerWidget {
  final int artistId;
  final String? localArtistName;

  const ArtistDetailsPage({
    super.key,
    required this.artistId,
    this.localArtistName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistDetailsAsync = ref.watch(artistDetailsViewModelProvider(
      artistId: artistId,
      localArtistName: localArtistName,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artista'),
      ),
      body: artistDetailsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('No se pudo cargar la información del artista.')),
        data: (details) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: details.artist.pictureMedium.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: details.artist.pictureMedium.replaceAll('250x250', '500x500'),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        child: const Icon(Icons.person, color: Colors.white, size: 100),
                      ),
                    )
                        : Container(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                details.artist.name,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              if (details.artist.name == 'Artista Desconocido')
                Text(
                  '(Desconocido)',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              if (details.localTracks.isNotEmpty) ...[
                const SizedBox(height: 32),
                Text('En tu biblioteca', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                ...details.localTracks.map((track) => SongListItem(track: track)),
              ],
              if (details.topTracks.isNotEmpty) ...[
                const SizedBox(height: 32),
                Text('Canciones Populares', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                ...details.topTracks.map((track) => SongListItem(track: track)),
              ],
              if (details.albums.isNotEmpty) ...[
                const SizedBox(height: 32),
                Text('Discografía', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: details.albums.length,
                    itemBuilder: (context, index) =>
                        AlbumCard(album: details.albums[index]),
                  ),
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}