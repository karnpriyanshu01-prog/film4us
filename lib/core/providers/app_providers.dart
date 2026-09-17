import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mock_movie_repository.dart';
import '../../data/services/download_manager.dart';
import '../../data/services/mock_download_manager.dart';
import '../../domain/repositories/movie_repository.dart';

/// Single place where concrete implementations are wired up.
///
/// Swapping [MockMovieRepository] for a future Supabase/API-backed
/// repository — or [MockDownloadManager] for a real downloader — only
/// requires changing the object created here. No screen or widget
/// depends on these concrete classes directly.
final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MockMovieRepository();
});

final downloadManagerProvider = Provider<DownloadManager>((ref) {
  final manager = MockDownloadManager();
  ref.onDispose(manager.dispose);
  return manager;
});
