import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import 'package:my_music/features/library/presentation/viewmodels/library_viewmodel.dart';

class TrackOptionsMenu extends ConsumerWidget {
  final Track track;
  const TrackOptionsMenu({super.key, required this.track});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryNotifier = ref.read(libraryViewModelProvider.notifier);
    final isInLibraryFuture = libraryNotifier.isInLibrary(track.id);

    return Wrap(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(track.albumCover),
          ),
          title: Text(track.title),
          subtitle: Text(track.artist.name),
        ),
        const Divider(),
        FutureBuilder<bool>(
          future: isInLibraryFuture,
          builder: (context, snapshot) {
            final isInLibrary = snapshot.data ?? false;
            return ListTile(
              leading: Icon(
                  isInLibrary ? Icons.remove_circle_outline : Icons.add_circle_outline),
              title: Text(
                  isInLibrary ? 'Quitar de Canciones' : 'Agregar a Canciones'),
              onTap: () {
                if (isInLibrary) {
                  libraryNotifier.removeTrackFromLibrary(track.id);
                } else {
                  libraryNotifier.addTrackToLibrary(track);
                }
                Navigator.pop(context);
              },
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_outline),
          title: const Text('Eliminar'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Compartir'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Información de la canción'),
          onTap: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (_) => TrackInfoDialog(track: track),
            );
          },
        ),
      ],
    );
  }
}

class TrackInfoDialog extends StatelessWidget {
  final Track track;
  const TrackInfoDialog({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Información'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Canción: ${track.title}'),
          Text('Artista: ${track.artist.name}'),
          Text('Álbum: ${track.albumTitle}'),
          Text('Duración: ${track.duration} segundos'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        )
      ],
    );
  }
}