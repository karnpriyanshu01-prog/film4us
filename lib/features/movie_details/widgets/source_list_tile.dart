import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/movie_source.dart';

/// One tappable, clearly Film4us-branded row per available source.
///
/// Only ever shows user-facing metadata (quality/language) — never any
/// internal provider/implementation detail.
class SourceListTile extends StatelessWidget {
  final MovieSource source;
  final VoidCallback onTap;

  const SourceListTile({super.key, required this.source, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final metadata = [
      if (source.quality != null) source.quality!,
      if (source.language != null) source.language!,
    ].join(' • ');

    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: const CircleAvatar(
          backgroundColor: AppColors.surfaceElevated,
          foregroundColor: AppColors.accent,
          child: Icon(Icons.play_arrow_rounded),
        ),
        title: Text(source.displayName, style: Theme.of(context).textTheme.titleMedium),
        subtitle: metadata.isNotEmpty
            ? Text(metadata, style: Theme.of(context).textTheme.bodySmall)
            : null,
        trailing: const Icon(Icons.chevron_right, color: AppColors.textTertiary),
      ),
    );
  }
}
