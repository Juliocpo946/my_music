import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_music/core/providers/settings_provider.dart';
import 'package:my_music/core/theme/theme_provider.dart';
import 'package:my_music/core/utils/app_colors.dart';
import 'package:my_music/features/settings/domain/repositories/settings_repository.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Color? get accentColor => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsRepositoryProvider);
    final accentColorNotifier = ref.read(accentColorNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil y Configuración'),
      ),
      body: ListView(
        children: [
          FutureBuilder<String?>(
            future: settings.getUserName(),
            builder: (context, snapshot) {
              final name = snapshot.data ?? 'Usuario';
              return ListTile(
                title: const Text('Apodo'),
                subtitle: Text(name),
                leading: const Icon(Icons.person),
                onTap: () => _showEditNameDialog(context, settings, name, ref),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Color de Acento'),
            subtitle: const Text('Personaliza la apariencia de la app'),
            onTap: () => _showColorPicker(
                context, ref.read(accentColorNotifierProvider).value, accentColorNotifier),
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('Géneros Favoritos'),
            subtitle: const Text('Modifica tus preferencias musicales'),
            onTap: () => context.push('/profile/edit-genres'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Acerca de'),
            subtitle: const Text('Versión 1.0.0'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.deepPurple),
            title: const Text('Powered by Deezer'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, SettingsRepository repo,
      String currentName, WidgetRef ref) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cambiar apodo'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nuevo apodo'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  repo.saveUserName(controller.text);
                  ref.invalidate(settingsRepositoryProvider);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showColorPicker(
      BuildContext context, Color? currentColor, AccentColorNotifier notifier) {
    final colors = {
      'Azul Eléctrico': AppColors.electricBlue,
      'Púrpura Neón': AppColors.neonPurple,
      'Verde Vibrante': AppColors.vibrantGreen,
      'Cian Aqua': AppColors.aquaCyan,
      'Magenta Intenso': AppColors.intenseMagenta,
    };

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Elige un color de acento',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            ...colors.entries.map((entry) {
              return ListTile(
                leading: CircleAvatar(backgroundColor: entry.value),
                title: Text(entry.key),
                trailing: currentColor == entry.value
                    ? const Icon(Icons.check_circle)
                    : null,
                onTap: () {
                  notifier.updateColor(entry.value);
                  Navigator.of(context).pop();
                },
              );
            }),
          ],
        );
      },
    );
  }
}