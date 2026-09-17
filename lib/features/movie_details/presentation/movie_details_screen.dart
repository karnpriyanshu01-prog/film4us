import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/movie_details.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/skeleton_box.dart';
import '../providers/movie_details_providers.dart';
import '../widgets/source_list_tile.dart';

/// Shows the movie's common poster/title/description once, followed by
/// the "Available Sources" list — the core multi-provider-normalization
/// requirement: one movie, many sources, never duplicate movie cards.
class MovieDetailsScreen extends ConsumerWidget {
  final String movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(movieDetailsProvider(movieId));

    return detailsAsync.when(
        loading: () => Scaffold(
          appBar: AppBar(),
          body: const _DetailsSkeleton(),
        ),
        error: (e, _) => Scaffold(
          appBar: AppBar(),
          body: ErrorView(onRetry: () => ref.invalidate(movieDetailsProvider(movieId))),
        ),
        data: (details) {
          if (details == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const ErrorView(message: 'Movie not found'),
            );
          }

          final movie = details.movie;
          return Scaffold(
            body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 260,
                flexibleSpace: FlexibleSpaceBar(
                  background: movie.backdropUrl != null
                      ? CachedNetworkImage(
                          imageUrl: movie.backdropUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(color: AppColors.surface),
                          errorWidget: (_, __, ___) => Container(color: AppColors.surface),
                        )
                      : Container(color: AppColors.surface),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      _MetadataRow(details: details),
                      if (movie.description != null) ...[
                        const SizedBox(height: 14),
                        Text(movie.description!, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                      const SizedBox(height: 28),
                      Text('Available Sources', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              if (details.sources.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: ErrorView(message: 'No sources available'),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList.separated(
                    itemCount: details.sources.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final source = details.sources[index];
                      return SourceListTile(
                        key: ValueKey(source.id),
                        source: source,
                        onTap: () => context.push(
                          '/movie/$movieId/source/${source.id}',
                          extra: {'movie': movie, 'source': source},
                        ),
                      );
                    },
                  ),
                ),
            ],
            ),
          );
        },
      );
  }
}

class _MetadataRow extends StatelessWidget {
  final MovieDetails details;
  const _MetadataRow({required this.details});

  @override
  Widget build(BuildContext context) {
    final movie = details.movie;
    final parts = <String>[
      if (movie.year != null) movie.year.toString(),
      if (details.runtimeMinutes != null) '${details.runtimeMinutes} min',
      if (movie.genres.isNotEmpty) movie.genres.join(', '),
    ];
    if (parts.isEmpty) return const SizedBox.shrink();
    return Text(
      parts.join('  •  '),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

class _DetailsSkeleton extends StatelessWidget {
  const _DetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SkeletonBox(height: 220, borderRadius: BorderRadius.all(Radius.circular(16))),
          const SizedBox(height: 20),
          const SkeletonBox(width: 200, height: 24),
          const SizedBox(height: 10),
          const SkeletonBox(width: 140, height: 14),
          const SizedBox(height: 20),
          const SkeletonBox(height: 60),
          const SizedBox(height: 28),
          const SkeletonBox(width: 160, height: 20),
          const SizedBox(height: 12),
          ...List.generate(
            3,
            (i) => const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: SkeletonBox(height: 64),
            ),
          ),
        ],
      ),
    );
  }
}
