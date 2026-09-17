import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/entities/movie_source.dart';
import '../../domain/repositories/movie_repository.dart';
import '../mock/mock_data.dart';

/// Development-only [MovieRepository] backed by static in-memory data.
///
/// Artificial delays simulate real network latency so loading states are
/// exercised during development. Replace this with a repository that
/// calls the Film4us API (backed by Supabase + authorized providers)
/// without changing any consuming widget or provider.
class MockMovieRepository implements MovieRepository {
  @override
  Future<List<Movie>> getFeaturedMovies() async {
    await _simulateLatency();
    return [MockData.pushpa2];
  }

  @override
  Future<List<Movie>> getLatestMovies() async {
    await _simulateLatency();
    return MockData.allMovies;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    await _simulateLatency();
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return [];

    // Simulates a backend that has already searched every enabled
    // provider and normalized duplicate hits into single movies.
    return MockData.allMovies
        .where((movie) => movie.title.toLowerCase().contains(normalized))
        .toList();
  }

  @override
  Future<MovieDetails?> getMovieDetails(String movieId) async {
    await _simulateLatency();
    return MockData.detailsFor(movieId);
  }

  @override
  Future<List<MovieSource>> getSources(String movieId) async {
    await _simulateLatency();
    return MockData.sourcesFor(movieId);
  }

  Future<void> _simulateLatency() =>
      Future.delayed(const Duration(milliseconds: 500));
}
