import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_source.dart';
import '../../../shared/widgets/movie_summary_header.dart';

/// Shown after a user picks a specific source: re-confirms the movie,
/// names the chosen source, and offers Watch Now / Download Now.
class SourceDetailsScreen extends ConsumerWidget {
  final Movie movie;
  final MovieSource source;

  const SourceDetailsScreen({super.key, required this.movie, required this.source});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(source.displayName)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MovieSummaryHeader(movie: movie),
              const SizedBox(height: 8),
              Text(source.displayName, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: source.watchUrl == null
                            ? null
                            : () => context.push(
                                  '/player',
                                  extra: {'movie': movie, 'source': source},
                                ),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('WATCH NOW'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: source.downloadUrl == null
                            ? null
                            : () => _startDownload(context, ref),
                        icon: const Icon(Icons.download_outlined),
                        label: const Text('DOWNLOAD NOW'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _startDownload(BuildContext context, WidgetRef ref) {
    ref.read(downloadManagerProvider).startDownload(
          movieId: movie.id,
          movieTitle: movie.title,
          posterUrl: movie.posterUrl,
          quality: source.quality,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Download started for ${movie.title}')),
    );
    context.push('/downloads');
  }
}
