import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/domain/entities/album.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/album_card.dart';
import '../widgets/artist_circle.dart';
import '../widgets/song_list_item.dart';
import '../widgets/section_header.dart';
import '../widgets/genre_chip.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      body: homeDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Hola, ${data.userName}',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Nuevos Lanzamientos'),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.newReleases.length,
                  itemBuilder: (context, index) =>
                      AlbumCard(album: data.newReleases[index]),
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Éxitos del Momento'),
              ...data.topTracks.map((track) => SongListItem(track: track)),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Artistas del Momento'),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.topArtists.length,
                  itemBuilder: (context, index) => Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 16),
                    child: ArtistCircle(artist: data.topArtists[index]),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (data.recommendations.isNotEmpty) ...[
                const SectionHeader(title: 'Podría gustarte'),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.recommendations.length,
                    itemBuilder: (context, index) {
                      final track = data.recommendations[index];
                      return SizedBox(
                        width: 160,
                        child: AlbumCard(
                          album: Album(
                            id: track.albumId,
                            title: track.title,
                            coverMedium: track.albumCover
                                .replaceAll('250x250', '500x500'),
                            artistName: track.artist.name,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Descubrir más'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              const SectionHeader(title: 'Géneros'),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children:
                data.genres.map((genre) => GenreChip(name: genre)).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}