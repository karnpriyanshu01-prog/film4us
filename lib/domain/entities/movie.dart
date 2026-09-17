import 'package:flutter/foundation.dart';

/// Core, immutable movie entity shared across the whole app.
///
/// A single [Movie] represents one title regardless of how many
/// authorized providers the future backend aggregated it from — the
/// backend is responsible for normalizing duplicate provider results
/// into one [Movie] with many [MovieSource]s.
@immutable
class Movie {
  final String id;
  final String title;
  final String? posterUrl;
  final String? backdropUrl;
  final String? description;
  final int? year;
  final List<String> genres;

  const Movie({
    required this.id,
    required this.title,
    this.posterUrl,
    this.backdropUrl,
    this.description,
    this.year,
    this.genres = const [],
  });

  @override
  bool operator ==(Object other) => other is Movie && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
