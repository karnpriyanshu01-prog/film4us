import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/movie.dart';

/// Poster-first movie card used in horizontal rails and search results.
///
/// Keeps a fixed 2:3 poster aspect ratio and degrades gracefully when a
/// poster is missing, per the design requirements.
class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final double width;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.width = 128,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${movie.title}${movie.year != null ? ', ${movie.year}' : ''}',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 2 / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  child: _Poster(url: movie.posterUrl),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),
              ),
              if (movie.year != null) ...[
                const SizedBox(height: 2),
                Text(
                  movie.year.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  final String? url;
  const _Poster({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return const _PosterFallback();
    }
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder: (context, _) => Container(color: AppColors.surface),
      errorWidget: (context, _, __) => const _PosterFallback(),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(
        Icons.local_movies_outlined,
        color: AppColors.textTertiary,
        size: 32,
      ),
    );
  }
}
