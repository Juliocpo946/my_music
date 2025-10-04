import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import 'package:my_music/features/library/presentation/viewmodels/library_viewmodel.dart';

class AddToPlaylistDialog extends ConsumerWidget {
  final Track track;
  const AddToPlaylistDialog({super.key, required this.track});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryState = ref.watch(libraryViewModelProvider);
    final libraryNotifier = ref.read(libraryViewModelProvider.notifier);

    return libraryState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (data) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Guardar en...',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            if (data.playlists.isEmpty)
              const ListTile(
                title: Text('No has creado ninguna playlist todavía.'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: data.playlists.length,
                itemBuilder: (context, index) {
                  final playlist = data.playlists[index];
                  return ListTile(
                    leading: const Icon(Icons.music_note),
                    title: Text(playlist.name),
                    onTap: () {
                      libraryNotifier.addTrackToPlaylist(playlist.id, track);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                            Text('Añadido a "${playlist.name}"')),
                      );
                    },
                  );
                },
              ),
          ],
        );
      },
    );
  }
}