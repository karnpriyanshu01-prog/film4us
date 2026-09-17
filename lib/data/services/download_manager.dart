import '../../domain/entities/download_item.dart';

/// Contract for starting/pausing/resuming/cancelling local downloads.
///
/// The frontend only ever schedules and tracks downloads through this
/// interface. It never performs unauthorized fetching, DRM bypass, or
/// arbitrary code execution — the actual authorized transfer will be
/// driven by the future backend-provided [DownloadItem.movieId] +
/// source, once that integration exists.
abstract class DownloadManager {
  Stream<List<DownloadItem>> watchDownloads();

  Future<void> startDownload({
    required String movieId,
    required String movieTitle,
    String? posterUrl,
    String? quality,
  });

  Future<void> pauseDownload(String downloadId);

  Future<void> resumeDownload(String downloadId);

  Future<void> cancelDownload(String downloadId);
}
