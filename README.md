# Film4us

Film4us is a minimal, cinematic, modern movie streaming **frontend** built
with Flutter. This phase ships the complete UI/UX layer, wired against a
mock/development data source, and architected so a future Supabase-backed
API (with multiple authorized `.cs3` providers) can be plugged in later
**without rewriting any screen**.

> **Scope note:** This repository contains the Flutter frontend only.
> There is no backend, no Supabase project, and no admin panel in this
> phase. All movie data, sources, and video URLs are static mock/sample
> data — see [`lib/data/mock/mock_data.dart`](lib/data/mock/mock_data.dart).

---

## Features

- **No account system** — the app opens directly into Home. No login,
  signup, profile, or account screens exist anywhere in the app.
- **Bottom navigation**: Home · Search · Downloads · Settings — nothing else.
- **Home** — one featured movie banner + a "Latest Movies" rail.
- **Search** — debounced search with a poster grid of results.
- **Movie Details** — one movie (poster/title/description/genres/runtime)
  with an **Available Sources** list.
- **Multi-provider normalization** — searching "Pushpa 2" returns **one**
  movie card with **four** sources (`Source 1`–`Source 4`), demonstrating
  how the future backend will aggregate multiple authorized `.cs3`
  providers into a single normalized result. No internal provider names,
  IDs, or implementation details are ever exposed in the UI.
- **Source Details** — re-confirms the movie, then offers **Watch Now**
  and **Download Now**.
- **Player** — a custom, dark, cinematic video player built on
  `video_player`: play/pause, seek bar, 10s rewind/forward, double-tap
  seek, fullscreen with landscape lock, volume, quality/audio/subtitle
  selection sheet, auto-hiding controls, loading/buffering/error states.
- **Downloads** — a local download manager abstraction with simulated
  progress, pause/resume/cancel, and an empty state.
- **Settings** — exactly three entries: Contact Us, Community, Copyright
  Alert.
- Polished loading (skeleton), empty, and error states on every screen.
- Fully responsive: works on small phones, large phones, and tablets.

## Explicitly out of scope (by design)

No login/signup/profile/account, no favorites/watch history, no
notifications, no subscriptions/payments, no theme or language settings,
no plugin manager, no Supabase backend, no admin panel, no arbitrary
remote code execution, no DRM bypass, no unauthorized scraping or
downloading. All source/video URLs in this build are safe, public-domain
sample content used purely to exercise the UI.

---

## Tech stack

| Concern              | Package |
|-----------------------|---------|
| State management      | `flutter_riverpod` |
| Navigation             | `go_router` (`StatefulShellRoute` for the bottom nav) |
| HTTP abstraction (future) | `dio` |
| Image loading/caching  | `cached_network_image` |
| Video playback         | `video_player` |
| Local file handling    | `path_provider` |
| Runtime permissions    | `permission_handler` |
| External links         | `url_launcher` |

Dependencies are kept intentionally minimal — nothing is included that
the app doesn't actually use.

---

## Architecture

```text
lib/
├── core/            # constants, theme, router, utils, errors, DI wiring
├── data/
│   ├── mock/        # static mock catalog (Pushpa 2, Inception, ...)
│   ├── repositories/# MockMovieRepository (implements domain contract)
│   ├── services/    # DownloadManager abstraction + mock implementation
│   └── models/      # (empty for now — see data/models/README.md)
├── domain/
│   ├── entities/    # Movie, MovieDetails, MovieSource, Subtitle, DownloadItem
│   └── repositories/# abstract MovieRepository contract
├── features/        # one folder per screen: home, search, movie_details,
│                     # source_details, player, downloads, settings
├── shared/
│   └── widgets/      # MovieCard, SkeletonBox, ErrorView, EmptyView, ...
└── main.dart
```

**The dependency direction that matters:** every screen and Riverpod
provider depends only on `domain/entities` and `domain/repositories`. The
concrete `MockMovieRepository` is created in exactly one place —
[`lib/core/providers/app_providers.dart`](lib/core/providers/app_providers.dart).

### Connecting the real backend later

```text
Flutter App  →  Film4us API  →  Supabase  →  Authorized Provider System  →  .cs3 Providers
```

To connect the future Supabase-backed API:

1. Implement `MovieRepository` (see
   [`lib/domain/repositories/movie_repository.dart`](lib/domain/repositories/movie_repository.dart))
   with a class that calls your real API via `dio`, e.g. `Film4usApiMovieRepository`.
2. Add JSON-mapping DTOs under `lib/data/models/` and map them to the
   existing `domain/entities` types.
3. Swap the single line in `movieRepositoryProvider`
   (`app_providers.dart`) to return your new implementation.
4. Do the same for `DownloadManager` if/when downloads become
   backend-authorized.

No screen, widget, or provider outside of those two files needs to change.
The UI never has and never will know that `.cs3` providers exist — it only
ever sees normalized `Movie` / `MovieSource` objects.

---

## Getting started

### Prerequisites
- Flutter SDK 3.27+ (`flutter --version`)
- Android Studio or VS Code with the Flutter/Dart extensions
- An Android emulator or physical device (this build ships Android
  configuration only; adding iOS support later just requires running
  `flutter create --platforms=ios .` in the project root)

### Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. Point the Android build at your local SDKs
cp android/local.properties.example android/local.properties
# then edit android/local.properties to set sdk.dir and flutter.sdk

# 3. Run
flutter run
```

### Project structure notes
- `main.dart` is intentionally tiny — it only sets up `ProviderScope` and
  `MaterialApp.router`.
- All theming lives in `core/theme/` — there's a single dark, cinematic
  theme; no theme switching, per the product scope.
- All routes are declared in `core/router/app_router.dart`.

---

## Sample/mock data

For this frontend-only phase, four movies are available:

- **Pushpa 2** — demonstrates the multi-source UI with 4 sources
- **Inception** — 2 sources
- **Interstellar** — 3 sources
- **Avatar** — 1 source

All posters/backdrops use a placeholder image service, and every
watch/download URL points at the same public-domain sample video
(Big Buck Bunny) so the player and download flows have something safe
and legal to exercise. None of this represents real, unauthorized
content, and none of it should be mistaken for production data.

---

## License

This is a frontend scaffold for further development. No third-party
branding, assets, or proprietary UI have been copied — the design system
in `core/theme/` is Film4us's own.
