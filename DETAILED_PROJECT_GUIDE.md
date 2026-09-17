# Film4us Project Guide

This document explains the project from the beginning to the advanced level so you can understand how it works, how to run it locally, and how to create a similar project yourself.

---

## 1. What this project is

Film4us is a Flutter movie streaming frontend app. It is not a full backend system. It is a UI-focused app that demonstrates:

- Home screen with featured movie banner
- Search screen with movie results
- Movie details screen
- Source selection
- Player screen
- Downloads flow
- Settings screen
- Dark cinematic theme

The app uses mock data and follows a clean architecture so later you can replace the mock repository with a real API or backend service without rewriting screens.

This project is a good example of:

- Flutter + Riverpod architecture
- Clean separation of UI and data
- Router-based navigation
- Theme customization
- Feature-based folder structure
- Local mock-data development flow

---

## 2. Project purpose and scope

This project is intended as a frontend prototype and foundation for a streaming app.

Important note:

- It does not include login/signup/authentication.
- It does not use a real database.
- It does not include backend APIs.
- It contains mock sample movies and sample video URLs.
- It is built as a clean base for future backend integration.

The architecture is designed so that a real repository can replace the mock repository later.

---

## 3. Technology stack

The project uses these main dependencies:

- Flutter SDK
- Dart
- flutter_riverpod for state management
- go_router for routing
- dio for future API calls
- cached_network_image for images
- video_player for video playback
- path_provider for local file access
- permission_handler for storage permissions
- url_launcher for external links

Main package definitions are in [pubspec.yaml](pubspec.yaml).

---

## 4. Folder structure explained

The project structure is:

```text
film4us/
├── android/                # Android project files
├── lib/
│   ├── core/               # app-wide config, theme, router, providers, utils
│   ├── data/               # mock data + repository implementations
│   ├── domain/             # entities and abstract contracts
│   ├── features/           # screen-specific modules
│   ├── shared/             # reusable widgets
│   ├── main.dart           # app entry point
│   └── ...
├── analysis_options.yaml
├── pubspec.yaml
├── README.md
├── .gitignore
├── android/local.properties.example
└── DETAILED_PROJECT_GUIDE.md
```

### 4.1 Root files

#### [pubspec.yaml](pubspec.yaml)
This file defines:

- app name
- Flutter SDK constraints
- dependencies
- dev dependencies
- Flutter configuration

This is the most important file for any Flutter project.

#### [analysis_options.yaml](analysis_options.yaml)
This is the linting configuration. It helps maintain code quality and catches common mistakes.

#### [README.md](README.md)
The main summary file for the project. It explains the app, stack, architecture, and setup.

#### [.gitignore](.gitignore)
Contains files and folders to ignore in Git, such as build artifacts, local SDK paths, and generated data.

---

## 5. Architecture explanation

The project follows a layered structure.

### 5.1 Core layer
The [lib/core](lib/core) folder contains things used globally:

- [lib/core/constants/app_constants.dart](lib/core/constants/app_constants.dart)
- [lib/core/theme/app_theme.dart](lib/core/theme/app_theme.dart)
- [lib/core/router/app_router.dart](lib/core/router/app_router.dart)
- [lib/core/providers/app_providers.dart](lib/core/providers/app_providers.dart)
- [lib/core/utils/debouncer.dart](lib/core/utils/debouncer.dart)

#### [lib/core/constants/app_constants.dart](lib/core/constants/app_constants.dart)
Stores app-wide values like:

- app name
- debounce time
- external URLs

This keeps UI screens free from hardcoded environment values.

#### [lib/core/theme/app_theme.dart](lib/core/theme/app_theme.dart)
Defines the app theme. Here the app uses a cinematic dark look with Material 3 styling.

#### [lib/core/router/app_router.dart](lib/core/router/app_router.dart)
Contains all routes and navigation logic.

Routes included:

- /home
- /search
- /downloads
- /settings
- /movie/:movieId
- /movie/:movieId/source/:sourceId
- /player
- /settings/contact
- /settings/community
- /settings/copyright

This project uses `go_router` and a `StatefulShellRoute` for bottom navigation.

#### [lib/core/providers/app_providers.dart](lib/core/providers/app_providers.dart)
This is the dependency injection / provider setup point.

It creates:

- `movieRepositoryProvider`
- `downloadManagerProvider`

This is important because later you can swap the mock repository with a real backend repository without rewriting the screens.

---

### 5.2 Domain layer
The [lib/domain](lib/domain) folder contains business entities and interfaces.

#### [lib/domain/entities/movie.dart](lib/domain/entities/movie.dart)
Defines the movie entity used across the app.

Fields usually include:

- id
- title
- description
- posterUrl
- backdropUrl
- year
- genres

#### [lib/domain/entities/movie_details.dart](lib/domain/entities/movie_details.dart)
Contains the detailed metadata for a movie, including:

- movie object
- runtime
- sources

#### [lib/domain/entities/movie_source.dart](lib/domain/entities/movie_source.dart)
Contains a single streaming source record.

It stores:

- source id
- display name
- watch URL
- download URL
- quality
- language
- subtitles

#### [lib/domain/entities/subtitle.dart](lib/domain/entities/subtitle.dart)
Defines subtitle metadata.

#### [lib/domain/entities/download_item.dart](lib/domain/entities/download_item.dart)
Represents a single download item.

#### [lib/domain/repositories/movie_repository.dart](lib/domain/repositories/movie_repository.dart)
This is the contract or abstraction. The UI depends on this interface instead of a concrete implementation.

This is a key clean architecture idea.

---

### 5.3 Data layer
The [lib/data](lib/data) folder contains the implementation and mock content.

#### [lib/data/mock/mock_data.dart](lib/data/mock/mock_data.dart)
This file includes mock movies, source data, and sample multimedia URLs.

The app uses it to simulate real movie data locally.

It contains:

- Pushpa 2
- Inception
- Interstellar
- Avatar

Every movie has:

- poster image URLs
- backdrop image URLs
- descriptions
- genres
- source lists

#### [lib/data/repositories/mock_movie_repository.dart](lib/data/repositories/mock_movie_repository.dart)
This is the current implementation of `MovieRepository`.

Instead of hitting a backend API, it returns static values with a simulated delay.

This is the place to replace when you connect a real API later.

#### [lib/data/services/download_manager.dart](lib/data/services/download_manager.dart)
Abstract download behavior interface.

#### [lib/data/services/mock_download_manager.dart](lib/data/services/mock_download_manager.dart)
Mock implementation that simulates download progress and status updates.

---

### 5.4 Features layer
The [lib/features](lib/features) folder contains each screen and its widgets.

#### Home feature
- [lib/features/home/presentation/home_screen.dart](lib/features/home/presentation/home_screen.dart)
- [lib/features/home/providers/home_providers.dart](lib/features/home/providers/home_providers.dart)
- [lib/features/home/widgets/featured_movie_banner.dart](lib/features/home/widgets/featured_movie_banner.dart)
- [lib/features/home/widgets/home_skeleton.dart](lib/features/home/widgets/home_skeleton.dart)

This is the landing screen of the app.

It shows:

- a featured banner
- latest movie section
- cards for each movie

#### Search feature
- [lib/features/search/presentation/search_screen.dart](lib/features/search/presentation/search_screen.dart)
- [lib/features/search/providers/search_providers.dart](lib/features/search/providers/search_providers.dart)

This is the movie search screen.

It uses:

- debounced text input
- search provider state
- grid-based result display

#### Movie details feature
- [lib/features/movie_details/presentation/movie_details_screen.dart](lib/features/movie_details/presentation/movie_details_screen.dart)
- [lib/features/movie_details/providers/movie_details_providers.dart](lib/features/movie_details/providers/movie_details_providers.dart)
- [lib/features/movie_details/widgets/source_list_tile.dart](lib/features/movie_details/widgets/source_list_tile.dart)

This shows metadata about a selected movie and its available sources.

#### Source details feature
- [lib/features/source_details/presentation/source_details_screen.dart](lib/features/source_details/presentation/source_details_screen.dart)

This screen confirms the selected source and lets the user watch or download.

#### Player feature
- [lib/features/player/presentation/player_screen.dart](lib/features/player/presentation/player_screen.dart)
- [lib/features/player/widgets/player_controls_overlay.dart](lib/features/player/widgets/player_controls_overlay.dart)
- [lib/features/player/widgets/player_settings_sheet.dart](lib/features/player/widgets/player_settings_sheet.dart)

This is the movie playback UI. It includes:

- play/pause
- seek
- fullscreen mode
- volume control
- quality selection
- audio selection
- subtitle selection
- buffering/loading states

#### Downloads feature
- [lib/features/downloads/presentation/downloads_screen.dart](lib/features/downloads/presentation/downloads_screen.dart)
- [lib/features/downloads/providers/downloads_providers.dart](lib/features/downloads/providers/downloads_providers.dart)
- [lib/features/downloads/widgets/download_item_card.dart](lib/features/downloads/widgets/download_item_card.dart)

This simulates a downloads screen with statuses like:

- downloading
- paused
- completed
- cancelled

#### Settings feature
- [lib/features/settings/presentation/settings_screen.dart](lib/features/settings/presentation/settings_screen.dart)
- [lib/features/settings/presentation/external_link_screen.dart](lib/features/settings/presentation/external_link_screen.dart)
- [lib/features/settings/presentation/copyright_alert_screen.dart](lib/features/settings/presentation/copyright_alert_screen.dart)
- [lib/features/settings/widgets/settings_tile.dart](lib/features/settings/widgets/settings_tile.dart)

This app keeps settings minimal and intentional.

---

### 5.5 Shared widgets
The [lib/shared/widgets](lib/shared/widgets) folder contains reusable UI pieces.

Examples:

- [lib/shared/widgets/empty_view.dart](lib/shared/widgets/empty_view.dart)
- [lib/shared/widgets/error_view.dart](lib/shared/widgets/error_view.dart)
- [lib/shared/widgets/movie_card.dart](lib/shared/widgets/movie_card.dart)
- [lib/shared/widgets/main_shell.dart](lib/shared/widgets/main_shell.dart)
- [lib/shared/widgets/skeleton_box.dart](lib/shared/widgets/skeleton_box.dart)
- [lib/shared/widgets/section_header.dart](lib/shared/widgets/section_header.dart)

These widgets are used across several feature screens to maintain consistency.

---

## 6. Important file-by-file overview

Here is a concise explanation of the most important project files:

### App entry
- [lib/main.dart](lib/main.dart) — app bootstrap and root `ProviderScope`

### App configuration
- [lib/core/theme/app_colors.dart](lib/core/theme/app_colors.dart) — central theme colors
- [lib/core/theme/app_theme.dart](lib/core/theme/app_theme.dart) — dark theme configuration
- [lib/core/constants/app_constants.dart](lib/core/constants/app_constants.dart) — shared constants

### Routing
- [lib/core/router/app_router.dart](lib/core/router/app_router.dart) — all routes and navigation

### Data access
- [lib/domain/repositories/movie_repository.dart](lib/domain/repositories/movie_repository.dart) — repository contract
- [lib/data/repositories/mock_movie_repository.dart](lib/data/repositories/mock_movie_repository.dart) — mock implementation
- [lib/data/mock/mock_data.dart](lib/data/mock/mock_data.dart) — static movie data

### UI screens
- [lib/features/home/presentation/home_screen.dart](lib/features/home/presentation/home_screen.dart)
- [lib/features/search/presentation/search_screen.dart](lib/features/search/presentation/search_screen.dart)
- [lib/features/movie_details/presentation/movie_details_screen.dart](lib/features/movie_details/presentation/movie_details_screen.dart)
- [lib/features/source_details/presentation/source_details_screen.dart](lib/features/source_details/presentation/source_details_screen.dart)
- [lib/features/player/presentation/player_screen.dart](lib/features/player/presentation/player_screen.dart)
- [lib/features/downloads/presentation/downloads_screen.dart](lib/features/downloads/presentation/downloads_screen.dart)
- [lib/features/settings/presentation/settings_screen.dart](lib/features/settings/presentation/settings_screen.dart)

### Shared UI helpers
- [lib/shared/widgets/error_view.dart](lib/shared/widgets/error_view.dart)
- [lib/shared/widgets/empty_view.dart](lib/shared/widgets/empty_view.dart)
- [lib/shared/widgets/skeleton_box.dart](lib/shared/widgets/skeleton_box.dart)
- [lib/shared/widgets/movie_card.dart](lib/shared/widgets/movie_card.dart)

---

## 7. How the app works

### Startup flow
When the app starts:

1. [lib/main.dart](lib/main.dart) runs `runApp(...)`
2. `ProviderScope` is created
3. `MaterialApp.router` is used
4. `appRouter` initializes the route graph
5. user lands on `/home`

### Data flow
The flow is:

- UI screen requests data via Riverpod provider
- provider calls a repository method
- repository returns mock data or future API data
- UI renders results and states

The cleaning separation is:

```text
UI -> Providers -> Repository -> Data Source
```

### Why this is clean architecture
UI code does not know where the data comes from. It only works with `MovieRepository` and domain entities.

That means later you can switch from:

- `MockMovieRepository`

To:

- `ApiMovieRepository`
- `SupabaseMovieRepository`
- real HTTP/Gateway implementation

without updating many screens.

---

## 8. How to run this project locally

### Step 1: install Flutter
Make sure Flutter is installed and available in PATH.

Run:

```bash
flutter --version
```

If Flutter is not detected, install it from the official Flutter SDK website.

### Step 2: check environment

Run:

```bash
flutter doctor
```

Expected result:

- Flutter installed
- Android toolchain working
- Android SDK configured
- device or emulator available

Possible issue on Windows:

- `Visual Studio` warning is only needed for Windows desktop builds.
- For Android app development, Android Studio + Android SDK is the main requirement.

### Step 3: install dependencies
In the project root:

```bash
flutter pub get
```

### Step 4: configure Android local properties
The project includes [android/local.properties.example](android/local.properties.example).

Create a local config file:

```bash
copy android\local.properties.example android\local.properties
```

Then update the paths to your actual SDK locations:

```properties
sdk.dir=C:\Users\YOUR_USERNAME\AppData\Local\Android\Sdk
flutter.sdk=C:\src\flutter
```

### Step 5: run the app
Choose a connected device or emulator, then run:

```bash
flutter run
```

If you want a specific device:

```bash
flutter devices
flutter run -d <device-id>
```

### Step 6: build release APK

For Android debug build:

```bash
flutter build apk --debug
```

For Android release build:

```bash
flutter build apk --release
```

For Android app bundle:

```bash
flutter build appbundle
```

---

## 9. How to run this project in VS Code

1. Open the folder in VS Code.
2. Install Flutter and Dart extensions.
3. Open a terminal in the project root.
4. Run `flutter pub get`.
5. Select a device/emulator.
6. Press F5 or use the Run and Debug option.

If no device is visible, make sure Android Studio is installed and an emulator is running.

---

## 10. Common setup issues and fixes

### Issue 1: Flutter command not found
Fix:

- Add Flutter to PATH
- Restart terminal or IDE

### Issue 2: Android SDK not found
Fix:

- Install Android Studio
- Install Android SDK
- Set correct path in `android/local.properties`

### Issue 3: No device connected
Fix:

- Start an Android emulator
- Or connect a physical Android device with USB debugging enabled

### Issue 4: `flutter doctor` shows Visual Studio missing
Fix:

- This does not block Android app development.
- It only affects Windows desktop app development.
- If you only need Android app work, it is not a blocker.

### Issue 5: Gradle build hangs or prompts
Fix:

- Ensure SDKs are configured correctly
- Run `flutter clean` if build state is corrupted
- Then run:

```bash
flutter pub get
flutter run
```

### Issue 6: project uses mock data only
This is expected for this phase. To integrate a real API, replace the repository implementation in [lib/core/providers/app_providers.dart](lib/core/providers/app_providers.dart) and [lib/data/repositories/mock_movie_repository.dart](lib/data/repositories/mock_movie_repository.dart).

---

## 11. What was checked and fixed

I validated the project with Flutter analysis and resolved deprecated widget API issues that were blocking a clean analyzer result.

The project currently reports:

```bash
flutter analyze
```

Result:

```text
No issues found!
```

This means the current project is free of analyzer-reported errors and warnings.

---

## 12. Clean architecture pattern used here

This project is a good template for future app creation. The main concept is:

- Domain = business data and interfaces
- Data = implementation and remote/mock data
- Features = UI screens and widgets
- Core = global configuration and routing
- Shared = common reusable widgets

This pattern helps keep code organized and easier to scale.

---

## 13. How to create a similar project from scratch

If you want to make a new Flutter project using a similar structure, follow these steps:

### Step 1: create project

```bash
flutter create my_app
```

### Step 2: set up folders
Create folders like:

```text
lib/
  core/
  data/
  domain/
  features/
  shared/
```

### Step 3: define domain models
Create your business entities first.

### Step 4: create repository contracts
Create abstract interfaces in `domain/repositories`.

### Step 5: create mock or API data sources
Implement repository classes in `data/repositories`.

### Step 6: create feature screens
Create each screen with its own widgets and providers.

### Step 7: wire providers
Register repository and service providers in a central provider file.

### Step 8: set up navigation
Define routes in `app_router.dart`.

### Step 9: add theme and constants
Keep colors, typography, and constants in core files.

### Step 10: run and test

```bash
flutter pub get
flutter run
```

---

## 14. Future upgrade ideas

This app is a strong starting point for a real production streaming app. You can evolve it by adding:

- Firebase or Supabase authentication
- real backend API integration
- user profiles and saved favorites
- proper video streaming backend
- real downloads with storage permission handling
- push notifications
- watch history and recommendations
- admin dashboard
- real content management system

---

## 15. Quick commands cheat sheet

```bash
flutter doctor
flutter pub get
flutter run
flutter analyze
flutter build apk --debug
flutter build apk --release
flutter build appbundle
```

---

## 16. Final notes

This project is a professional frontend scaffold for a movie streaming app. It already shows clean architecture, state management, reusable widgets, route management, theme design, and good app flow structure. It is especially useful as a learning project or as the foundation for a larger production app.

The main learning takeaway is this:

- UI should not depend on details of the backend.
- Repositories abstract data access.
- Providers handle state.
- Screens stay focused and simple.
- Routing and theme are centralized.

This is exactly the kind of structure you want in your next project when scaling software properly.

---

## 17. Documentation status

The project guide has been created and is stored in:

- [DETAILED_PROJECT_GUIDE.md](DETAILED_PROJECT_GUIDE.md)

This guide is intended to help you understand the app from beginner to advanced level and to help you build similar projects on your own.
