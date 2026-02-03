import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider =
    NotifierProvider<NowPlayingMoviesNotifier, List<Movie>>(
      NowPlayingMoviesNotifier.new,
    );

final upcomingMoviesProvider =
    NotifierProvider<UpcomingMoviesNotifier, List<Movie>>(
      UpcomingMoviesNotifier.new,
    );

final popularMoviesProvider =
    NotifierProvider<PopularMoviesNotifier, List<Movie>>(
      PopularMoviesNotifier.new,
    );

typedef MovieCallback = Future<List<Movie>> Function({required int page});

class NowPlayingMoviesNotifier extends Notifier<List<Movie>> {
  int currentPage = 0;

  @override
  List<Movie> build() {
    return [];
  }

  Future<void> loadNextPage() async {
    currentPage++;
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
  }
}

class UpcomingMoviesNotifier extends Notifier<List<Movie>> {
  int currentPage = 0;

  @override
  List<Movie> build() {
    return [];
  }

  Future<void> loadNextPage() async {
    currentPage++;
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
  }
}

class PopularMoviesNotifier extends Notifier<List<Movie>> {
  int currentPage = 0;

  @override
  List<Movie> build() {
    return [];
  }

  Future<void> loadNextPage() async {
    currentPage++;
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
  }
}
