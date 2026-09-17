import 'package:flutter/foundation.dart';
import 'movie.dart';
import 'movie_source.dart';

/// A [Movie] plus its detail-only fields and the list of normalized,
/// aggregated sources available for it.
@immutable
class MovieDetails {
  final Movie movie;
  final int? runtimeMinutes;
  final List<MovieSource> sources;

  const MovieDetails({
    required this.movie,
    this.runtimeMinutes,
    this.sources = const [],
  });
}
