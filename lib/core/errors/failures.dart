/// Lightweight, UI-agnostic failure type returned by repositories.
///
/// Using a sealed failure type (instead of throwing raw exceptions from
/// data sources) keeps the UI layer decoupled from how a future
/// Supabase/API repository implementation reports errors.
class AppFailure implements Exception {
  final String message;
  const AppFailure(this.message);

  @override
  String toString() => message;
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'Unable to connect. Check your connection.']);
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure([super.message = 'Not found.']);
}

class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = 'Something went wrong.']);
}
