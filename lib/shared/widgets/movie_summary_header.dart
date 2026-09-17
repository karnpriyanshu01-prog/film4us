import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/movie.dart';

/// Compact poster + title + description block reused on the Source
/// Details screen so the movie context stays visible after picking a
/// source, without duplicating layout code.
class MovieSummaryHeader extends StatelessWidget {
  final Movie movie;

  const MovieSummaryHeader({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            child: SizedBox(
              width: 140,
              height: 210,
              child: movie.posterUrl != null
                  ? CachedNetworkImage(
                      imageUrl: movie.posterUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppColors.surface),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.surface,
                        child: const Icon(Icons.local_movies_outlined,
                            color: AppColors.textTertiary),
                      ),
                    )
                  : Container(
                      color: AppColors.surface,
                      child: const Icon(Icons.local_movies_outlined,
                          color: AppColors.textTertiary),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            movie.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (movie.description != null) ...[
            const SizedBox(height: 8),
            Text(
              movie.description!,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
