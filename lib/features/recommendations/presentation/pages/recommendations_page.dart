import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/features/home/presentation/widgets/album_card.dart';
import '../viewmodels/recommendations_viewmodel.dart';

class RecommendationsPage extends ConsumerWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(recommendationsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Podría Gustarte'),
      ),
      body: recommendationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (albums) {
          if (albums.isEmpty) {
            return const Center(
              child: Text(
                  'No hay recomendaciones por ahora.\n¡Escucha más música!'),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              return AlbumCard(album: albums[index]);
            },
          );
        },
      ),
    );
  }
}