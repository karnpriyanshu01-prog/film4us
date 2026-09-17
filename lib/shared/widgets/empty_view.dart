import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Minimal empty state: one icon, one line, optional short subtext.
class EmptyView extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;

  const EmptyView({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.movie_filter_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textTertiary, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
