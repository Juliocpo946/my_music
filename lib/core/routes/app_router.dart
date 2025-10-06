import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_music/features/album_details/presentation/pages/album_details_page.dart';
import 'package:my_music/features/artist_details/presentation/pages/artist_details_page.dart';
import 'package:my_music/features/genre_details/presentation/pages/genre_details_page.dart';
import 'package:my_music/features/home/presentation/pages/home_page.dart';
import 'package:my_music/features/library/presentation/pages/library_page.dart';
import 'package:my_music/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:my_music/features/player/presentation/pages/player_page.dart';
import 'package:my_music/features/profile/presentation/pages/edit_genres_page.dart';
import 'package:my_music/features/profile/presentation/pages/hidden_songs_page.dart';
import 'package:my_music/features/profile/presentation/pages/profile_page.dart';
import 'package:my_music/features/recommendations/presentation/pages/recommendations_page.dart';
import 'package:my_music/features/search/presentation/pages/search_page.dart';
import 'package:my_music/shared/widgets/main_shell.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/playlist_details/presentation/pages/playlist_details_page.dart';
import '../providers/settings_provider.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(Ref ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    redirect: (context, state) async {
      final onboardingComplete =
      await settingsRepository.isOnboardingComplete();
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
            navigatorKey: _shellNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomePage()),
                routes: [
                  GoRoute(
                    path: 'album/:id',
                    builder: (context, state) {
                      final albumId = int.parse(state.pathParameters['id']!);
                      final title = state.uri.queryParameters['title'];
                      return AlbumDetailsPage(
                        albumId: albumId,
                        localAlbumTitle: title,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'artist/:id',
                    builder: (context, state) {
                      final artistId = int.parse(state.pathParameters['id']!);
                      final name = state.uri.queryParameters['name'];
                      return ArtistDetailsPage(
                        artistId: artistId,
                        localArtistName: name,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'recommendations',
                    builder: (context, state) {
                      return const RecommendationsPage();
                    },
                  ),
                  GoRoute(
                    path: 'genre/:name',
                    builder: (context, state) {
                      final genreName = state.pathParameters['name']!;
                      return GenreDetailsPage(genreName: genreName);
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
                  routes: [
                    GoRoute(
                      path: 'playlist/:id',
                      builder: (context, state) {
                        final playlistId =
                        int.parse(state.pathParameters['id']!);
                        return PlaylistDetailsPage(playlistId: playlistId);
                      },
                    ),
                  ]),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: '/profile',
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: ProfilePage(),
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit-genres',
                      builder: (context, state) => const EditGenresPage(),
                    ),
                    GoRoute(
                      path: 'hidden-songs',
                      builder: (context, state) => const HiddenSongsPage(),
                    ),
                  ]),
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