import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/movie.dart';

/// Large cinematic backdrop shown at the top of Home for the featured
/// movie, with a title, short description, and a single primary action.
class FeaturedMovieBanner extends StatelessWidget {
  final Movie movie;
  final VoidCallback onWatchNow;
  final VoidCallback onTap;

  const FeaturedMovieBanner({
    super.key,
    required this.movie,
    required this.onWatchNow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (movie.backdropUrl != null)
                CachedNetworkImage(
                  imageUrl: movie.backdropUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.surface),
                  errorWidget: (_, __, ___) => Container(color: AppColors.surface),
                )
              else
                Container(color: AppColors.surface),
              // Subtle gradient purely for text legibility — not decorative excess.
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                    stops: [0.4, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (movie.description != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        movie.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary.withValues(alpha: 0.85),
                            ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: onWatchNow,
                      icon: const Icon(Icons.play_arrow, size: 20),
                      label: const Text('Watch Now'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
