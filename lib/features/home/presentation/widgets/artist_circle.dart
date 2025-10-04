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
      onTap: () => context.push('/home/artist/${artist.id}'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.grey.shade800,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: artist.pictureMedium,
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                errorWidget: (context, url, error) =>
                const Icon(Icons.person, size: 40),
                fit: BoxFit.cover,
                width: 90,
                height: 90,
              ),
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