import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_music/features/album_details/presentation/pages/album_details_page.dart';
import 'package:my_music/features/artist_details/presentation/pages/artist_details_page.dart';
import 'package:my_music/features/home/presentation/pages/home_page.dart';
import 'package:my_music/features/library/presentation/pages/library_page.dart';
import 'package:my_music/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:my_music/features/player/presentation/pages/player_page.dart';
import 'package:my_music/features/search/presentation/pages/search_page.dart';
import 'package:my_music/shared/widgets/main_shell.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/settings_provider.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    redirect: (context, state) async {
      final onboardingComplete = await settingsRepository.isOnboardingComplete();
      final isGoingToOnboarding = state.matchedLocation == '/onboarding';

      if (!onboardingComplete && !isGoingToOnboarding) {
        return '/onboarding';
      }
      if (onboardingComplete && isGoingToOnboarding) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomePage()),
                routes: [
                  GoRoute(
                    path: 'album/:id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final albumId = int.parse(state.pathParameters['id']!);
                      return AlbumDetailsPage(albumId: albumId);
                    },
                  ),
                  GoRoute(
                    path: 'artist/:id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final artistId =
                      int.parse(state.pathParameters['id']!);
                      return ArtistDetailsPage(artistId: artistId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                pageBuilder: (context, state) =>
                const NoTransitionPage(child: SearchPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                pageBuilder: (context, state) =>
                const NoTransitionPage(child: LibraryPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: Center(child: Text('Página de Perfil')),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/player',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const PlayerPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
}