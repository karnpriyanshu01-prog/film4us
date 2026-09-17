import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/download_item.dart';

/// One row in the Downloads list: poster, title, quality, progress and
/// pause/resume/cancel actions appropriate to the current status.
class DownloadItemCard extends StatelessWidget {
  final DownloadItem item;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onCancel;

  const DownloadItemCard({
    super.key,
    required this.item,
    required this.onPause,
    required this.onResume,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              child: SizedBox(
                width: 60,
                height: 90,
                child: item.posterUrl != null
                    ? CachedNetworkImage(
                        imageUrl: item.posterUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: AppColors.surfaceElevated),
                        errorWidget: (_, __, ___) => Container(color: AppColors.surfaceElevated),
                      )
                    : Container(color: AppColors.surfaceElevated),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.movieTitle, style: Theme.of(context).textTheme.titleMedium),
                  if (item.quality != null) ...[
                    const SizedBox(height: 2),
                    Text(item.quality!, style: Theme.of(context).textTheme.bodySmall),
                  ],
                  const SizedBox(height: 10),
                  _StatusLine(item: item),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: item.progress,
                      minHeight: 4,
                      backgroundColor: AppColors.border,
                      color: item.status == DownloadStatus.failed
                          ? AppColors.error
                          : AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _Actions(item: item, onPause: onPause, onResume: onResume, onCancel: onCancel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  final DownloadItem item;
  const _StatusLine({required this.item});

  @override
  Widget build(BuildContext context) {
    final percent = (item.progress * 100).round();
    final label = switch (item.status) {
      DownloadStatus.downloading => 'Downloading... $percent%',
      DownloadStatus.paused => 'Paused • $percent%',
      DownloadStatus.completed => 'Completed',
      DownloadStatus.failed => 'Failed',
    };
    return Text(label, style: Theme.of(context).textTheme.bodySmall);
  }
}

class _Actions extends StatelessWidget {
  final DownloadItem item;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onCancel;

  const _Actions({
    required this.item,
    required this.onPause,
    required this.onResume,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[];

    if (item.status == DownloadStatus.downloading) {
      buttons.add(_ActionChip(label: 'Pause', onTap: onPause));
    } else if (item.status == DownloadStatus.paused) {
      buttons.add(_ActionChip(label: 'Resume', onTap: onResume));
    }

    if (item.status != DownloadStatus.completed) {
      buttons.add(_ActionChip(label: 'Cancel', onTap: onCancel));
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Wrap(spacing: 8, children: buttons);
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ActionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
