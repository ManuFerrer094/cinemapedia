import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteMoviesProvider =
    NotifierProvider<FavoriteMoviesNotifier, Map<int, Movie>>(
      FavoriteMoviesNotifier.new,
    );

/*
  {
    1234: Movie,
    1235: Movie,
    1236: Movie,
  }
*/

class FavoriteMoviesNotifier extends Notifier<Map<int, Movie>> {
  int currentPage = 0;

  @override
  Map<int, Movie> build() {
    loadMovies();
    return {};
  }

  Future<List<Movie>> loadNextPage() async {
    final localStorageRepository = ref.watch(localStorageRepositoryProvider);
    final movies =
        await localStorageRepository.loadFavoriteMovies(offset: currentPage * 10);
    currentPage++;

    final tempMoviesMap = <int, Movie>{};
    for (final movie in movies) {
      tempMoviesMap[movie.id] = movie;
    }

    state = {...state, ...tempMoviesMap};
    return movies;
  }

  Future<void> toggleFavorite(Movie movie) async {
    final localStorageRepository = ref.watch(localStorageRepositoryProvider);
    await localStorageRepository.toggleFavoriteMovie(movie);
    final bool isMovieInFavorites = state[movie.id] != null;

    if (isMovieInFavorites) {
      state.remove(movie.id);
      state = <int, Movie>{...state};
    } else {
      state = {...state, movie.id: movie};
    }
  }

  Future<void> loadMovies() async {
    final localStorageRepository = ref.watch(localStorageRepositoryProvider);
    final movies = await localStorageRepository.loadFavoriteMovies(
      limit: 1000,
      offset: 0,
    );

    final tempMoviesMap = <int, Movie>{};
    for (final movie in movies) {
      tempMoviesMap[movie.id] = movie;
    }

    state = tempMoviesMap;
  }
}
