import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/album.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  const AlbumCard({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final encodedTitle = Uri.encodeComponent(album.title);
        final isLocal = album.id.toString().length <= 5;
        context.push('/home/album/${album.id}?isLocal=$isLocal&title=$encodedTitle');
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: album.coverMedium.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: album.coverMedium,
                height: 160,
                width: 160,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 160,
                  width: 160,
                  color: Colors.grey[850],
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error),
              )
                  : Container(
                height: 160,
                width: 160,
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(album.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge),
            Text(album.artistName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}