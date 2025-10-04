import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/presentation/widgets/album_card.dart';
import 'package:my_music/features/home/presentation/widgets/song_list_item.dart';
import '../viewmodels/artist_details_viewmodel.dart';

class ArtistDetailsPage extends ConsumerWidget {
  final int artistId;
  const ArtistDetailsPage({super.key, required this.artistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistDetailsAsync =
    ref.watch(artistDetailsViewModelProvider(artistId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artista'),
      ),
      body: artistDetailsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (details) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: details.artist.pictureMedium.replaceAll('250x250', '500x500'),
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                details.artist.name,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text('Top 5 Canciones',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              ...details.topTracks
                  .map((track) => SongListItem(track: track)),
              const SizedBox(height: 32),
              Text('Discografía',
                  style: Theme.of(context).textTheme.headlineMedium),
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
            ],
          );
        },
      ),
    );
  }
}