import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/empty_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/movie_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/skeleton_box.dart';
import '../providers/home_providers.dart';
import '../widgets/featured_movie_banner.dart';
import '../widgets/home_skeleton.dart';

/// The Home screen: one featured movie, one "Latest Movies" rail.
///
/// Deliberately does not grow beyond these two sections, per the
/// "do not clutter the Home screen" requirement.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsync = ref.watch(featuredMoviesProvider);
    final latestAsync = ref.watch(latestMoviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(featuredMoviesProvider);
          ref.invalidate(latestMoviesProvider);
        },
        child: featuredAsync.when(
          loading: () => const HomeSkeleton(),
          error: (e, _) => ErrorView(
            onRetry: () => ref.invalidate(featuredMoviesProvider),
          ),
          data: (featured) {
            final featuredMovie = featured.isNotEmpty ? featured.first : null;
            return ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                if (featuredMovie != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                    child: FeaturedMovieBanner(
                      movie: featuredMovie,
                      onWatchNow: () => context.push('/movie/${featuredMovie.id}'),
                      onTap: () => context.push('/movie/${featuredMovie.id}'),
                    ),
                  ),
                const SectionHeader(title: 'Latest Movies'),
                SizedBox(
                  height: 244,
                  child: latestAsync.when(
                    loading: () => const _LatestMoviesSkeleton(),
                    error: (e, _) => ErrorView(
                      onRetry: () => ref.invalidate(latestMoviesProvider),
                    ),
                    data: (movies) {
                      if (movies.isEmpty) {
                        return const EmptyView(title: 'No movies available');
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return MovieCard(
                            key: ValueKey(movie.id),
                            movie: movie,
                            onTap: () => context.push('/movie/${movie.id}'),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LatestMoviesSkeleton extends StatelessWidget {
  const _LatestMoviesSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, __) => const SkeletonBox(width: 128, height: 230),
    );
  }
}
