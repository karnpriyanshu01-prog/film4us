import 'package:flutter/foundation.dart';

/// Lifecycle state of a local download.
enum DownloadStatus { downloading, paused, completed, failed }

/// Represents one user-initiated download tracked locally on-device.
///
/// This is a local, frontend-only concept for this phase. The actual
/// authorized transfer will be orchestrated by the future backend.
@immutable
class DownloadItem {
  final String id;
  final String movieId;
  final String movieTitle;
  final String? posterUrl;
  final String? quality;
  final double progress; // 0.0 - 1.0
  final DownloadStatus status;

  const DownloadItem({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    this.posterUrl,
    this.quality,
    this.progress = 0,
    this.status = DownloadStatus.downloading,
  });

  DownloadItem copyWith({
    double? progress,
    DownloadStatus? status,
  }) {
    return DownloadItem(
      id: id,
      movieId: movieId,
      movieTitle: movieTitle,
      posterUrl: posterUrl,
      quality: quality,
      progress: progress ?? this.progress,
      status: status ?? this.status,
    );
  }
}
