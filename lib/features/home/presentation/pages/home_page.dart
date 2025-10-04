import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return homeDataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (data) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Hola, Alex',
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Nuevos Lanzamientos'),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.newReleases.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) =>
                    ArtistCircle(artist: data.topArtists[index]),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Géneros'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children:
                data.genres.map((genre) => GenreChip(name: genre)).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}