import 'package:flutter_riverpod/legacy.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class MoviesSlideshowState {
  final List<Movie> movies;
  final int currentPage;

  MoviesSlideshowState({this.movies = const [], this.currentPage = 0});

  MoviesSlideshowState copyWith({List<Movie>? movies, int? currentPage}) {
    return MoviesSlideshowState(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class MoviesSlideshowNotifier extends StateNotifier<MoviesSlideshowState> {
  MoviesSlideshowNotifier() : super(MoviesSlideshowState());

  void setMovies(List<Movie> movies) {
    state = state.copyWith(movies: movies);
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }
}

final moviesSlideshowProvider = StateNotifierProvider<MoviesSlideshowNotifier, MoviesSlideshowState>((ref) {
  return MoviesSlideshowNotifier();
});
