import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../domain/entities/movie.dart';

final featuredMoviesProvider = FutureProvider.autoDispose<List<Movie>>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getFeaturedMovies();
});

final latestMoviesProvider = FutureProvider.autoDispose<List<Movie>>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getLatestMovies();
});
