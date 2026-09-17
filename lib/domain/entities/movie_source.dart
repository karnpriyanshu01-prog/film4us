import 'package:flutter/foundation.dart';
import 'subtitle.dart';

/// A single watchable/downloadable source for a movie.
///
/// Sources are normalized, backend-provided entries. The frontend never
/// knows (and must never expose) which authorized provider a source
/// came from — only a clean, Film4us-branded display name.
@immutable
class MovieSource {
  final String id;
  final String displayName;
  final String? watchUrl;
  final String? downloadUrl;
  final String? quality;
  final String? language;
  final List<Subtitle> subtitles;

  const MovieSource({
    required this.id,
    required this.displayName,
    this.watchUrl,
    this.downloadUrl,
    this.quality,
    this.language,
    this.subtitles = const [],
  });
}
