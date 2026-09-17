# data/models

This phase's `MockMovieRepository` returns `domain/entities` objects
directly, so no JSON-mapping DTOs exist yet.

When a real backend (Supabase/API) is connected, add request/response
model classes here (e.g. `movie_dto.dart` with `fromJson`/`toJson`) and
map them to the immutable `domain/entities` types before returning them
from the repository implementation. Screens and providers will not need
any changes — they only depend on `domain/entities` and
`domain/repositories`.
