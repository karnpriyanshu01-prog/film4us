import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../domain/entities/download_item.dart';

final downloadsStreamProvider = StreamProvider.autoDispose<List<DownloadItem>>((ref) {
  final manager = ref.watch(downloadManagerProvider);
  return manager.watchDownloads();
});
