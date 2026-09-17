import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../domain/entities/movie_details.dart';

final movieDetailsProvider =
    FutureProvider.autoDispose.family<MovieDetails?, String>((ref, movieId) {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getMovieDetails(movieId);
});
