import 'package:flutter/foundation.dart';

/// A single subtitle track available for a [MovieSource].
@immutable
class Subtitle {
  final String language;
  final String url;

  const Subtitle({required this.language, required this.url});
}
