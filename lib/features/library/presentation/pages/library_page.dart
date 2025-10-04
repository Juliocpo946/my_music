import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/albums_tab.dart';
import '../widgets/artists_tab.dart';
import '../widgets/favorite_songs_tab.dart';
import '../widgets/library_songs_tab.dart';
import '../widgets/playlists_tab.dart';
import '../viewmodels/library_viewmodel.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearching = false;
  String _searchQuery = '';
  final _searchController = TextEditingController();
  final _playlistNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _playlistNameController.dispose();
    super.dispose();
  }

  void _showCreatePlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear nueva playlist'),
          content: TextField(
            controller: _playlistNameController,
            autofocus: true,
            decoration:
            const InputDecoration(hintText: "Nombre de la playlist"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final name = _playlistNameController.text;
                if (name.isNotEmpty) {
                  ref
                      .read(libraryViewModelProvider.notifier)
                      .createPlaylist(name);
                  Navigator.of(context).pop();
                  _playlistNameController.clear();
                }
              },
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Buscar en tu biblioteca...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
        )
            : const Text('Mi Biblioteca'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
            icon: Icon(_isSearching ? Icons.close : Icons.search),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Canciones'),
            Tab(text: 'Canciones Favoritas'),
            Tab(text: 'Playlists'),
            Tab(text: 'Álbumes'),
            Tab(text: 'Artistas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LibrarySongsTab(searchQuery: _searchQuery),
          FavoriteSongsTab(searchQuery: _searchQuery),
          PlaylistsTab(searchQuery: _searchQuery),
          AlbumsTab(searchQuery: _searchQuery),
          ArtistsTab(searchQuery: _searchQuery),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePlaylistDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}