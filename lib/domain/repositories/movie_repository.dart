import '../entities/movie.dart';
import '../entities/movie_details.dart';
import '../entities/movie_source.dart';

/// Contract the UI depends on for all movie data.
///
/// The UI and Riverpod providers only ever talk to this abstraction.
/// For this phase, [MockMovieRepository] (see data/repositories) backs
/// it with static sample data. Later, a `SupabaseMovieRepository` (or an
/// HTTP-backed `Film4usApiMovieRepository` in front of Supabase) can
/// implement this exact interface — powered by multiple authorized
/// `.cs3` providers on the backend — with zero changes to any screen.
abstract class MovieRepository {
  /// Returns featured/curated movies for the Home screen.
  Future<List<Movie>> getFeaturedMovies();

  /// Returns the latest movies for the Home screen.
  Future<List<Movie>> getLatestMovies();

  /// Searches across all backend-enabled providers and returns one
  /// normalized [Movie] per distinct title — never one card per provider.
  Future<List<Movie>> searchMovies(String query);

  /// Fetches full details (including aggregated sources) for a movie.
  Future<MovieDetails?> getMovieDetails(String movieId);

  /// Fetches only the normalized sources for a movie.
  Future<List<MovieSource>> getSources(String movieId);
}
