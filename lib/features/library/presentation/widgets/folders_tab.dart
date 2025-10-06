import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/presentation/widgets/song_list_item.dart';
import 'package:my_music/features/library/presentation/viewmodels/library_viewmodel.dart';

class FoldersTab extends ConsumerWidget {
  final String searchQuery;
  const FoldersTab({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryState = ref.watch(libraryViewModelProvider);

    return libraryState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (data) {
        final localTracks = data.libraryTracks.where((t) => t.isLocal).toList();
        final folders = localTracks.map((t) => t.filePath!.substring(0, t.filePath!.lastIndexOf('/'))).toSet().toList();

        final filteredFolders = folders.where((folder) {
          final query = searchQuery.toLowerCase();
          return folder.toLowerCase().contains(query);
        }).toList();

        if (filteredFolders.isEmpty) {
          return Center(
            child: Text(searchQuery.isEmpty
                ? 'No se encontraron carpetas con música.'
                : 'No se encontraron carpetas.'),
          );
        }

        return ListView.builder(
          itemCount: filteredFolders.length,
          itemBuilder: (context, index) {
            final folderPath = filteredFolders[index];
            final folderName = folderPath.split('/').last;
            return ListTile(
              leading: const Icon(Icons.folder),
              title: Text(folderName),
              subtitle: Text(folderPath),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FolderSongsPage(folderPath: folderPath),
                ));
              },
            );
          },
        );
      },
    );
  }
}

class FolderSongsPage extends ConsumerWidget {
  final String folderPath;
  const FolderSongsPage({super.key, required this.folderPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryState = ref.watch(libraryViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(folderPath.split('/').last),
      ),
      body: libraryState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) {
          final tracks = data.libraryTracks
              .where((t) => t.isLocal && (t.filePath?.startsWith(folderPath) ?? false))
              .toList();

          if (tracks.isEmpty) {
            return const Center(
              child: Text('No hay canciones en esta carpeta.'),
            );
          }
          return ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              return SongListItem(track: tracks[index]);
            },
          );
        },
      ),
    );
  }
}