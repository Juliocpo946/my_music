import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/library/presentation/viewmodels/library_viewmodel.dart';

class HiddenSongsPage extends ConsumerWidget {
  const HiddenSongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hiddenSongsAsync = ref.watch(hiddenTracksProvider);
    final libraryNotifier = ref.read(libraryViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Santuario'),
      ),
      body: hiddenSongsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (tracks) {
          if (tracks.isEmpty) {
            return const Center(
              child: Text('El Santuario está vacío.'),
            );
          }
          return ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return ListTile(
                leading: const Icon(Icons.music_note),
                title: Text(track.title),
                subtitle: Text(track.artist.name),
                trailing: TextButton(
                  onPressed: () {
                    libraryNotifier.unhideTrack(track);
                  },
                  child: const Text('Restaurar'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}