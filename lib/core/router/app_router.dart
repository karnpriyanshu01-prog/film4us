import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_source.dart';
import '../../features/downloads/presentation/downloads_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/movie_details/presentation/movie_details_screen.dart';
import '../../features/player/presentation/player_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/settings/presentation/copyright_alert_screen.dart';
import '../../features/settings/presentation/external_link_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/source_details/presentation/source_details_screen.dart';
import '../constants/app_constants.dart';
import '../../shared/widgets/main_shell.dart';

/// Central navigation graph for Film4us.
///
/// Uses a [StatefulShellRoute] so the four bottom-nav tabs (Home,
/// Search, Downloads, Settings) each keep their own navigation stack,
/// and top-level routes (movie details, source details, player,
/// settings sub-pages) push on top of whichever tab is active.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/downloads', builder: (context, state) => const DownloadsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
        ]),
      ],
    ),

    // Movie details — reachable from Home and Search.
    GoRoute(
      path: '/movie/:movieId',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => MovieDetailsScreen(
        movieId: state.pathParameters['movieId']!,
      ),
      routes: [
        // Source details — nested so the back button returns to details.
        GoRoute(
          path: 'source/:sourceId',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final extra = state.extra as Map<String, Object?>?;
            final movie = extra?['movie'] as Movie?;
            final source = extra?['source'] as MovieSource?;
            if (movie == null || source == null) {
              return const _MissingDataScreen();
            }
            return SourceDetailsScreen(movie: movie, source: source);
          },
        ),
      ],
    ),

    // Full-screen player, opened from Source Details.
    GoRoute(
      path: '/player',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, Object?>?;
        final movie = extra?['movie'] as Movie?;
        final source = extra?['source'] as MovieSource?;
        if (movie == null || source == null) {
          return const _MissingDataScreen();
        }
        return PlayerScreen(movie: movie, source: source);
      },
    ),

    // Settings sub-pages.
    GoRoute(
      path: '/settings/contact',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ExternalLinkScreen(
        title: 'Contact Us',
        icon: Icons.mail_outline,
        description: 'Have a question or feedback for the Film4us team? '
            'Reach out and we\'ll get back to you.',
        url: AppConstants.contactUsUrl,
        buttonLabel: 'Contact Us',
      ),
    ),
    GoRoute(
      path: '/settings/community',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ExternalLinkScreen(
        title: 'Community',
        icon: Icons.groups_outlined,
        description: 'Join the Film4us community to discuss releases, '
            'share feedback, and stay up to date.',
        url: AppConstants.communityUrl,
        buttonLabel: 'Join Community',
      ),
    ),
    GoRoute(
      path: '/settings/copyright',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const CopyrightAlertScreen(),
    ),
  ],
);

class _MissingDataScreen extends StatelessWidget {
  const _MissingDataScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Something went wrong')),
    );
  }
}
