import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/presentation/widgets/album_card.dart';
import 'package:my_music/features/home/presentation/widgets/artist_circle.dart';
import 'package:my_music/features/home/presentation/widgets/song_list_item.dart';
import '../viewmodels/search_state.dart';
import '../viewmodels/search_viewmodel.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchViewModelProvider);
    final searchNotifier = ref.read(searchViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            onChanged: (query) => searchNotifier.search(query),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Buscar canciones, artistas, álbumes',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: searchState.query.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _textController.clear();
                  searchNotifier.clearSearch();
                },
              )
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          if (searchState.query.isNotEmpty) ...[
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Canciones'),
                Tab(text: 'Artistas'),
                Tab(text: 'Álbumes'),
              ],
            ),
            const SizedBox(height: 16),
            Text('Resultados',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Expanded(
              child: _buildResults(searchState),
            ),
          ] else
            const Expanded(
              child: Center(
                child: Text('Explora nuevos horizontes'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResults(SearchState searchState) {
    if (searchState.isLoading && searchState.results == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (searchState.error != null) {
      return Center(child: Text(searchState.error!));
    }
    if (searchState.results == null) {
      return const SizedBox.shrink();
    }

    return TabBarView(
      controller: _tabController,
      children: [
        ListView.builder(
          itemCount: searchState.results!.tracks.length,
          itemBuilder: (context, index) {
            return SongListItem(track: searchState.results!.tracks[index]);
          },
        ),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: searchState.results!.artists.length,
          itemBuilder: (context, index) {
            return ArtistCircle(artist: searchState.results!.artists[index]);
          },
        ),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: searchState.results!.albums.length,
          itemBuilder: (context, index) {
            return AlbumCard(album: searchState.results!.albums[index]);
          },
        ),
      ],
    );
  }
}