import 'package:flutter/material.dart';
import 'package:my_music/features/home/domain/entities/track.dart';

class TrackDetailsDialog extends StatelessWidget {
  final Track track;

  const TrackDetailsDialog({super.key, required this.track});

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final secs = twoDigits(duration.inSeconds.remainder(60));
    if (hours > 0) {
      return "$hours:$minutes:$secs";
    }
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Detalles de la Canción'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            _buildDetailRow('Título:', track.title),
            _buildDetailRow('Artista:', track.artist.name),
            _buildDetailRow('Álbum:', track.albumTitle),
            _buildDetailRow('Duración:', _formatDuration(track.duration)),
            _buildDetailRow('Ruta:', track.filePath ?? 'No disponible'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cerrar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 2),
          Text(value),
        ],
      ),
    );
  }
}