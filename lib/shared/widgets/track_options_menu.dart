import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import 'package:my_music/features/library/presentation/viewmodels/library_viewmodel.dart';
import 'package:my_music/shared/widgets/add_to_playlist_dialog.dart';
import 'package:my_music/shared/widgets/track_details_dialog.dart';

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
          leading: track.isLocal
              ? const Icon(Icons.music_note)
              : CircleAvatar(
            backgroundImage: NetworkImage(track.albumCover),
          ),
          title: Text(track.title),
          subtitle: Text(track.artist.name),
        ),
        const Divider(),
        if (track.isLocal) ...[
          ListTile(
            leading: const Icon(Icons.shield_moon_outlined),
            title: const Text('Enviar al Santuario'),
            onTap: () {
              libraryNotifier.hideTrack(track);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Canción enviada al Santuario')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Eliminar archivo'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Eliminar archivo'),
                  content: Text(
                      '¿Estás seguro de que quieres eliminar "${track.title}" del dispositivo? Esta acción no se puede deshacer.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          if (track.filePath != null) {
                            final file = File(track.filePath!);
                            if (await file.exists()) {
                              await file.delete();
                            }
                          }
                          libraryNotifier.removeTrackFromLibrary(track);
                        } catch (e) {
                          //
                        }
                        Navigator.pop(context);
                      },
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Detalles'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => TrackDetailsDialog(track: track),
              );
            },
          ),
        ] else ...[
          FutureBuilder<bool>(
            future: isInLibraryFuture,
            builder: (context, snapshot) {
              final isInLibrary = snapshot.data ?? false;
              return ListTile(
                leading: Icon(isInLibrary
                    ? Icons.remove_circle_outline
                    : Icons.add_circle_outline),
                title: Text(isInLibrary
                    ? 'Quitar de Canciones'
                    : 'Agregar a Canciones'),
                onTap: () {
                  if (isInLibrary) {
                    libraryNotifier.removeTrackFromLibrary(track);
                  } else {
                    libraryNotifier.addTrackToLibrary(track);
                  }
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
        ListTile(
          leading: const Icon(Icons.playlist_add),
          title: const Text('Agregar a playlist'),
          onTap: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              builder: (_) => AddToPlaylistDialog(track: track),
            );
          },
        ),
        if (!track.isLocal)
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Compartir'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}