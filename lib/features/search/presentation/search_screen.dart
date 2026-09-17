import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/empty_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/skeleton_box.dart';
import '../providers/search_providers.dart';

/// Search screen: a single input field and a poster grid of results.
///
/// Each result represents one normalized movie (never one card per
/// provider) — see [SearchNotifier] / [MovieRepository.searchMovies].
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          ref.read(searchProvider.notifier).onQueryChanged('');
                          setState(() {});
                        },
                      ),
              ),
              onChanged: (value) {
                ref.read(searchProvider.notifier).onQueryChanged(value);
                setState(() {});
              },
            ),
          ),
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  Widget _buildBody(SearchState state) {
    switch (state.status) {
      case SearchStatus.idle:
        return const EmptyView(
          title: 'Search for a movie',
          subtitle: 'Try a title like "Inception"',
          icon: Icons.search,
        );
      case SearchStatus.loading:
        return const _ResultsSkeleton();
      case SearchStatus.error:
        return ErrorView(
          message: state.errorMessage ?? 'Something went wrong',
          onRetry: () =>
              ref.read(searchProvider.notifier).onQueryChanged(state.query),
        );
      case SearchStatus.success:
        if (state.results.isEmpty) {
          return const EmptyView(
            title: 'No movies found',
            subtitle: 'Try another search',
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 160,
            childAspectRatio: 0.56,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
          ),
          itemCount: state.results.length,
          itemBuilder: (context, index) {
            final movie = state.results[index];
            return _SearchResultCard(
              key: ValueKey(movie.id),
              title: movie.title,
              year: movie.year,
              posterUrl: movie.posterUrl,
              onTap: () => context.push('/movie/${movie.id}'),
            );
          },
        );
    }
  }
}

class _ResultsSkeleton extends StatelessWidget {
  const _ResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 160,
        childAspectRatio: 0.56,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const SkeletonBox(),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final String title;
  final int? year;
  final String? posterUrl;
  final VoidCallback onTap;

  const _SearchResultCard({
    super.key,
    required this.title,
    required this.year,
    required this.posterUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: posterUrl != null
                  ? CachedNetworkImage(
                      imageUrl: posterUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (_, __) => const _PosterFallback(),
                      errorWidget: (_, __, ___) => const _PosterFallback(),
                    )
                  : const _PosterFallback(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
          if (year != null) ...[
            const SizedBox(height: 2),
            Text(year.toString(), style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardTheme.color,
      alignment: Alignment.center,
      child: const Icon(Icons.local_movies_outlined),
    );
  }
}
