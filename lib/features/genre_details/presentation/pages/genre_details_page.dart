import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/presentation/widgets/album_card.dart';
import 'package:my_music/features/home/presentation/widgets/artist_circle.dart';
import 'package:my_music/features/home/presentation/widgets/song_list_item.dart';
import '../viewmodels/genre_details_viewmodel.dart';

class GenreDetailsPage extends ConsumerStatefulWidget {
  final String genreName;
  const GenreDetailsPage({super.key, required this.genreName});

  @override
  ConsumerState<GenreDetailsPage> createState() => _GenreDetailsPageState();
}

class _GenreDetailsPageState extends ConsumerState<GenreDetailsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailsAsync =
    ref.watch(genreDetailsViewModelProvider(widget.genreName));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.genreName),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Canciones'),
            Tab(text: 'Artistas'),
            Tab(text: 'Álbumes'),
          ],
        ),
      ),
      body: detailsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) => TabBarView(
          controller: _tabController,
          children: [
            ListView.builder(
              itemCount: data.tracks.length,
              itemBuilder: (context, index) {
                return SongListItem(track: data.tracks[index]);
              },
            ),
            GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: data.artists.length,
              itemBuilder: (context, index) {
                return ArtistCircle(artist: data.artists[index]);
              },
            ),
            GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: data.albums.length,
              itemBuilder: (context, index) {
                return AlbumCard(album: data.albums[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}