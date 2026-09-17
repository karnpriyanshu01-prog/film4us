import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/skeleton_box.dart';

/// Skeleton shown while the featured banner and latest movies load.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: SkeletonBox(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
        ),
        const SizedBox(height: 28),
        const SkeletonBox(width: 140, height: 20),
        const SizedBox(height: 12),
        SizedBox(
          height: 244,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, __) => const SkeletonBox(width: 128, height: 230),
          ),
        ),
      ],
    );
  }
}
