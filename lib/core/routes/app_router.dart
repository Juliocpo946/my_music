import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_music/features/album_details/presentation/pages/album_details_page.dart';
import 'package:my_music/features/artist_details/presentation/pages/artist_details_page.dart';
import 'package:my_music/features/home/presentation/pages/home_page.dart';
import 'package:my_music/features/library/presentation/pages/library_page.dart';
import 'package:my_music/features/player/presentation/pages/player_page.dart';
import 'package:my_music/features/search/presentation/pages/search_page.dart';
import 'package:my_music/shared/widgets/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) =>
          const NoTransitionPage(child: HomePage()),
        ),
        GoRoute(
          path: '/explore',
          pageBuilder: (context, state) =>
          const NoTransitionPage(child: SearchPage()),
        ),
        GoRoute(
          path: '/library',
          pageBuilder: (context, state) =>
          const NoTransitionPage(child: LibraryPage()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: Center(child: Text('Página de Perfil')),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/album/:id',
      builder: (context, state) {
        final albumId = int.parse(state.pathParameters['id']!);
        return AlbumDetailsPage(albumId: albumId);
      },
    ),
    GoRoute(
      path: '/artist/:id',
      builder: (context, state) {
        final artistId = int.parse(state.pathParameters['id']!);
        return ArtistDetailsPage(artistId: artistId);
      },
    ),
    GoRoute(
      path: '/player',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: const PlayerPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeOut)),
              ),
              child: child,
            );
          },
        );
      },
    ),
  ],
);