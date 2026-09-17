import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/entities/movie_source.dart';
import '../../domain/entities/subtitle.dart';

/// Static development/mock data used by [MockMovieRepository].
///
/// Posters/backdrops use a generic placeholder image service and all
/// watch/download URLs point at a public-domain sample video
/// (Big Buck Bunny) purely so the player/downloads UI has something
/// safe to render. None of this represents real, unauthorized content.
class MockData {
  MockData._();

  static const String _sampleVideoUrl =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  static const Movie pushpa2 = Movie(
    id: 'movie_pushpa_2',
    title: 'Pushpa 2',
    posterUrl: 'https://picsum.photos/seed/pushpa2poster/500/750',
    backdropUrl: 'https://picsum.photos/seed/pushpa2backdrop/1200/700',
    description:
        'The rise of a red sandalwood smuggler continues as he faces new '
        'rivals and higher stakes in this action-packed sequel.',
    year: 2024,
    genres: ['Action', 'Drama'],
  );

  static const Movie inception = Movie(
    id: 'movie_inception',
    title: 'Inception',
    posterUrl: 'https://picsum.photos/seed/inceptionposter/500/750',
    backdropUrl: 'https://picsum.photos/seed/inceptionbackdrop/1200/700',
    description:
        'A skilled thief who steals corporate secrets through dream-sharing '
        'technology is given a chance to erase his past crimes.',
    year: 2010,
    genres: ['Sci-Fi', 'Thriller'],
  );

  static const Movie interstellar = Movie(
    id: 'movie_interstellar',
    title: 'Interstellar',
    posterUrl: 'https://picsum.photos/seed/interstellarposter/500/750',
    backdropUrl: 'https://picsum.photos/seed/interstellarbackdrop/1200/700',
    description:
        'A team of explorers travel through a wormhole in space in an '
        'attempt to ensure humanity\'s survival.',
    year: 2014,
    genres: ['Sci-Fi', 'Adventure'],
  );

  static const Movie avatar = Movie(
    id: 'movie_avatar',
    title: 'Avatar',
    posterUrl: 'https://picsum.photos/seed/avatarposter/500/750',
    backdropUrl: 'https://picsum.photos/seed/avatarbackdrop/1200/700',
    description:
        'A paraplegic marine dispatched to the moon Pandora becomes torn '
        'between following orders and protecting the world he feels is home.',
    year: 2009,
    genres: ['Sci-Fi', 'Adventure'],
  );

  static const List<Movie> allMovies = [pushpa2, inception, interstellar, avatar];

  /// Demonstrates the multi-provider normalization requirement: several
  /// authorized providers found "Pushpa 2", but the frontend only ever
  /// sees one movie with several sources.
  static const Map<String, List<MovieSource>> _sourcesByMovieId = {
    'movie_pushpa_2': [
      MovieSource(
        id: 'src_1',
        displayName: 'Source 1',
        watchUrl: _sampleVideoUrl,
        downloadUrl: _sampleVideoUrl,
        quality: '1080p',
        language: 'Telugu',
        subtitles: [Subtitle(language: 'English', url: 'https://example.com/subs/en.vtt')],
      ),
      MovieSource(
        id: 'src_2',
        displayName: 'Source 2',
        watchUrl: _sampleVideoUrl,
        downloadUrl: _sampleVideoUrl,
        quality: '720p',
        language: 'Hindi',
        subtitles: [Subtitle(language: 'English', url: 'https://example.com/subs/en.vtt')],
      ),
      MovieSource(
        id: 'src_3',
        displayName: 'Source 3',
        watchUrl: _sampleVideoUrl,
        downloadUrl: _sampleVideoUrl,
        quality: '1080p',
        language: 'Tamil',
      ),
      MovieSource(
        id: 'src_4',
        displayName: 'Source 4',
        watchUrl: _sampleVideoUrl,
        downloadUrl: _sampleVideoUrl,
        quality: '480p',
        language: 'Telugu',
      ),
    ],
    'movie_inception': [
      MovieSource(
        id: 'src_1',
        displayName: 'Source 1',
        watchUrl: _sampleVideoUrl,
        downloadUrl: _sampleVideoUrl,
        quality: '1080p',
        language: 'English',
        subtitles: [Subtitle(language: 'English', url: 'https://example.com/subs/en.vtt')],
      ),
      MovieSource(
        id: 'src_2',
        displayName: 'Source 2',
        watchUrl: _sampleVideoUrl,
        downloadUrl: _sampleVideoUrl,
        quality: '720p',
        language: 'English',
      ),
    ],
    'movie_interstellar': [
      MovieSource(
        id: 'src_1',
        displayName: 'Source 1',
        watchUrl: _sampleVideoUrl,
        downloadUrl: _sampleVideoUrl,
        quality: '1080p',
        language: 'English',
      ),
      MovieSource(
        id: 'src_2',
        displayName: 'Source 2',
        watchUrl: _sampleVideoUrl,
        downloadUrl: _sampleVideoUrl,
        quality: '4K',
        language: 'English',
      ),
      MovieSource(
        id: 'src_3',
        displayName: 'Source 3',
        watchUrl: _sampleVideoUrl,
        downloadUrl: _sampleVideoUrl,
        quality: '720p',
        language: 'English',
      ),
    ],
    'movie_avatar': [
      MovieSource(
        id: 'src_1',
        displayName: 'Source 1',
        watchUrl: _sampleVideoUrl,
        downloadUrl: _sampleVideoUrl,
        quality: '1080p',
        language: 'English',
      ),
    ],
  };

  static const Map<String, int> _runtimeByMovieId = {
    'movie_pushpa_2': 199,
    'movie_inception': 148,
    'movie_interstellar': 169,
    'movie_avatar': 162,
  };

  static List<MovieSource> sourcesFor(String movieId) =>
      List.unmodifiable(_sourcesByMovieId[movieId] ?? const []);

  static MovieDetails? detailsFor(String movieId) {
    final movie = allMovies.where((m) => m.id == movieId).firstOrNull;
    if (movie == null) return null;
    return MovieDetails(
      movie: movie,
      runtimeMinutes: _runtimeByMovieId[movieId],
      sources: sourcesFor(movieId),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
