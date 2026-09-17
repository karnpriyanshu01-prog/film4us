import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/utils/debouncer.dart';
import '../../../domain/entities/movie.dart';

enum SearchStatus { idle, loading, success, error }

class SearchState {
  final String query;
  final SearchStatus status;
  final List<Movie> results;
  final String? errorMessage;

  const SearchState({
    this.query = '',
    this.status = SearchStatus.idle,
    this.results = const [],
    this.errorMessage,
  });

  SearchState copyWith({
    String? query,
    SearchStatus? status,
    List<Movie>? results,
    String? errorMessage,
  }) {
    return SearchState(
      query: query ?? this.query,
      status: status ?? this.status,
      results: results ?? this.results,
      errorMessage: errorMessage,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final Ref ref;
  final Debouncer _debouncer = Debouncer(delay: AppConstants.searchDebounce);

  SearchNotifier(this.ref) : super(const SearchState());

  void onQueryChanged(String query) {
    state = state.copyWith(query: query);

    if (query.trim().isEmpty) {
      _debouncer.dispose();
      state = state.copyWith(status: SearchStatus.idle, results: []);
      return;
    }

    _debouncer.run(() => _search(query));
  }

  Future<void> _search(String query) async {
    state = state.copyWith(status: SearchStatus.loading);
    try {
      final repository = ref.read(movieRepositoryProvider);
      final results = await repository.searchMovies(query);
      state = state.copyWith(status: SearchStatus.success, results: results);
    } catch (_) {
      state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: 'Something went wrong',
      );
    }
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}

final searchProvider =
    StateNotifierProvider.autoDispose<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});
