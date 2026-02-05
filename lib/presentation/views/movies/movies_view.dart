import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoviesView extends ConsumerStatefulWidget {
  const MoviesView({super.key});

  @override
  MoviesViewState createState() => MoviesViewState();
}

class MoviesViewState extends ConsumerState<MoviesView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);

    return ListView(
      children: [
        CustomAppbar(),
        MoviesSlideshow(movies: nowPlayingMovies),
        
        MovieHorizontalListview(
          movies: nowPlayingMovies,
          title: 'En cines',
          subTitle: 'Lunes 21',
          loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
        ),
        
        MovieHorizontalListview(
          movies: upcomingMovies,
          title: 'Próximamente',
          subTitle: 'En este mes',
          loadNextPage: () => ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
        ),

        MovieHorizontalListview(
          movies: popularMovies,
          title: 'Populares',
          subTitle: 'Recientemente',
          loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage(),
        ),
      ],
    );
  }
}
