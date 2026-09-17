/// Static, app-wide constant values.
///
/// Keeping these in one place makes it trivial to swap mock values for
/// real backend-driven configuration later without touching UI code.
class AppConstants {
  AppConstants._();

  static const String appName = 'Film4us';

  // Debounce delay used by the search screen.
  static const Duration searchDebounce = Duration(milliseconds: 450);

  // Placeholder destinations for the Settings screen.
  // These will eventually be provided by the backend/remote config.
  static const String contactUsUrl = 'https://film4us.example.com/contact';
  static const String communityUrl = 'https://film4us.example.com/community';
}
