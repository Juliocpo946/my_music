import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_music/core/providers/settings_provider.dart';
import 'package:my_music/features/home/presentation/providers/genres_provider.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _nameController = TextEditingController();
  final Set<String> _selectedGenres = {};

  Future<void> _completeOnboarding() async {
    if (_nameController.text.isEmpty || _selectedGenres.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa tu nombre y elige al menos un género.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final settingsRepo = ref.read(settingsRepositoryProvider);

    await settingsRepo.saveUserName(_nameController.text);
    await settingsRepo.saveGenres(_selectedGenres.toList());
    await settingsRepo.completeOnboarding();

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final genresAsync = ref.watch(genresProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bienvenido a MyMusic',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text('Primero, dinos cómo quieres que te llamemos.',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tu apodo o nombre'),
              ),
              const SizedBox(height: 32),
              Text('Ahora, elige tus géneros favoritos',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              Expanded(
                child: genresAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                  const Center(child: Text('No se pudieron cargar los géneros')),
                  data: (genres) => SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: genres.map((genre) {
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
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _completeOnboarding,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('¡Empezar!'),
              )
            ],
          ),
        ),
      ),
    );
  }
}