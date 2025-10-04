import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_music/shared/widgets/mini_player.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    final bool showAppBar = _shouldShowAppBar(location);

    return Scaffold(
      appBar: showAppBar ? _buildAppBar(context, location) : null,
      body: Column(
        children: [
          Expanded(child: child),
          const MiniPlayer(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(location),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explorar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note), label: 'Biblioteca'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  bool _shouldShowAppBar(String location) {
    return location.startsWith('/home') ||
        location.startsWith('/explore') ||
        location.startsWith('/profile');
  }

  AppBar _buildAppBar(BuildContext context, String location) {
    return AppBar(
      title: Text(_getTitleForLocation(location)),
      actions: _getActionsForLocation(location),
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/library')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  String _getTitleForLocation(String location) {
    if (location.startsWith('/home')) return 'Inicio';
    if (location.startsWith('/explore')) return 'Buscar';
    if (location.startsWith('/profile')) return 'Perfil';
    return '';
  }

  List<Widget>? _getActionsForLocation(String location) {
    if (location.startsWith('/home')) {
      return [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {},
        ),
      ];
    }
    return null;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/home');
        break;
      case 1:
        GoRouter.of(context).go('/explore');
        break;
      case 2:
        GoRouter.of(context).go('/library');
        break;
      case 3:
        GoRouter.of(context).go('/profile');
        break;
    }
  }
}