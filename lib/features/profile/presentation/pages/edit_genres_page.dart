import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/core/providers/settings_provider.dart';
import 'package:my_music/features/home/presentation/providers/genres_provider.dart';

class EditGenresPage extends ConsumerStatefulWidget {
  const EditGenresPage({super.key});

  @override
  ConsumerState<EditGenresPage> createState() => _EditGenresPageState();
}

class _EditGenresPageState extends ConsumerState<EditGenresPage> {
  final Set<String> _selectedGenres = {};
  bool _initialLoad = false;

  @override
  Widget build(BuildContext context) {
    final genresAsync = ref.watch(genresProvider);
    final settingsRepo = ref.watch(settingsRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Géneros'),
        actions: [
          TextButton(
            onPressed: () async {
              await settingsRepo.saveGenres(_selectedGenres.toList());
              if (mounted) Navigator.of(context).pop();
            },
            child: const Text('Guardar'),
          )
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: settingsRepo.getGenres(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!_initialLoad) {
            _selectedGenres.addAll(snapshot.data!);
            _initialLoad = true;
          }

          return genresAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => const Center(child: Text('Error al cargar géneros')),
            data: (allGenres) => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: allGenres.map((genre) {
                  final isSelected = _selectedGenres.contains(genre);
                  return ChoiceChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedGenres.add(genre);
                        } else {
                          _selectedGenres.remove(genre);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}