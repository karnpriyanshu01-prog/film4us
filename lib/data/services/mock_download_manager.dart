import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/download_item.dart';
import 'download_manager.dart';

/// Development [DownloadManager] that simulates progress locally.
///
/// This does not fetch any remote video data — it only demonstrates the
/// download lifecycle (queue, progress, pause/resume/cancel) that the
/// real backend-integrated downloader will plug into later. Simulated
/// files are tracked under the app's own documents directory only.
class MockDownloadManager implements DownloadManager {
  final Map<String, DownloadItem> _items = {};
  final Map<String, Timer> _timers = {};
  final _controller = StreamController<List<DownloadItem>>.broadcast();

  @override
  Stream<List<DownloadItem>> watchDownloads() {
    // Emit current state immediately to new listeners.
    Future.microtask(() => _emit());
    return _controller.stream;
  }

  @override
  Future<void> startDownload({
    required String movieId,
    required String movieTitle,
    String? posterUrl,
    String? quality,
  }) async {
    await _ensureStoragePermission();
    await _ensureAppDirectory();

    final id = '${movieId}_${DateTime.now().millisecondsSinceEpoch}';
    _items[id] = DownloadItem(
      id: id,
      movieId: movieId,
      movieTitle: movieTitle,
      posterUrl: posterUrl,
      quality: quality,
    );
    _emit();
    _tick(id);
  }

  @override
  Future<void> pauseDownload(String downloadId) async {
    _timers[downloadId]?.cancel();
    final item = _items[downloadId];
    if (item == null) return;
    _items[downloadId] = item.copyWith(status: DownloadStatus.paused);
    _emit();
  }

  @override
  Future<void> resumeDownload(String downloadId) async {
    final item = _items[downloadId];
    if (item == null) return;
    _items[downloadId] = item.copyWith(status: DownloadStatus.downloading);
    _emit();
    _tick(downloadId);
  }

  @override
  Future<void> cancelDownload(String downloadId) async {
    _timers[downloadId]?.cancel();
    _timers.remove(downloadId);
    _items.remove(downloadId);
    _emit();
  }

  void _tick(String id) {
    _timers[id]?.cancel();
    _timers[id] = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      final item = _items[id];
      if (item == null || item.status != DownloadStatus.downloading) {
        timer.cancel();
        return;
      }
      final nextProgress = (item.progress + 0.05).clamp(0.0, 1.0);
      final completed = nextProgress >= 1.0;
      _items[id] = item.copyWith(
        progress: nextProgress,
        status: completed ? DownloadStatus.completed : DownloadStatus.downloading,
      );
      _emit();
      if (completed) timer.cancel();
    });
  }

  void _emit() {
    if (_controller.isClosed) return;
    _controller.add(_items.values.toList(growable: false));
  }

  Future<void> _ensureStoragePermission() async {
    if (!Platform.isAndroid) return;
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<Directory> _ensureAppDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${dir.path}/film4us_downloads');
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }
    return downloadsDir;
  }

  void dispose() {
    for (final t in _timers.values) {
      t.cancel();
    }
    _controller.close();
  }
}
