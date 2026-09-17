import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/empty_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/skeleton_box.dart';
import '../providers/downloads_providers.dart';
import '../widgets/download_item_card.dart';

/// Downloads screen: a simple list of local/mock download items.
class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadsAsync = ref.watch(downloadsStreamProvider);
    final manager = ref.read(downloadManagerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: downloadsAsync.when(
        loading: () => const _DownloadsSkeleton(),
        error: (e, _) => const ErrorView(message: 'Something went wrong'),
        data: (downloads) {
          if (downloads.isEmpty) {
            return const EmptyView(
              title: 'No downloads yet',
              icon: Icons.download_outlined,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: downloads.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = downloads[index];
              return DownloadItemCard(
                key: ValueKey(item.id),
                item: item,
                onPause: () => manager.pauseDownload(item.id),
                onResume: () => manager.resumeDownload(item.id),
                onCancel: () => manager.cancelDownload(item.id),
              );
            },
          );
        },
      ),
    );
  }
}

class _DownloadsSkeleton extends StatelessWidget {
  const _DownloadsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const SkeletonBox(height: 110),
    );
  }
}
