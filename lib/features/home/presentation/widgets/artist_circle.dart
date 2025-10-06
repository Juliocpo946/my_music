import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/artist.dart';

class ArtistCircle extends StatelessWidget {
  final Artist artist;
  const ArtistCircle({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final encodedName = Uri.encodeComponent(artist.name);
        final isLocal = artist.id.toString().length <= 5;
        context.push('/home/artist/${artist.id}?isLocal=$isLocal&name=$encodedName');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
            child: ClipOval(
              child: artist.pictureMedium.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: artist.pictureMedium,
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2.0)),
                errorWidget: (context, url, error) =>
                const Icon(Icons.person, size: 40),
                fit: BoxFit.cover,
                width: 90,
                height: 90,
              )
                  : const Icon(Icons.person, size: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            artist.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}