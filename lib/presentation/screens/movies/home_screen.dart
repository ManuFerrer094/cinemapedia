

import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {

  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  int currentIndex = 0;

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

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        children: [
          CustomAppbar(),
          MoviesSlideshow(movies: nowPlayingMovies),
          
          MovieHorizontalListview(
            movies: nowPlayingMovies,
            label: 'En cines',
            subLabel: 'Lunes 21',
            loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
          ),
          
          MovieHorizontalListview(
            movies: upcomingMovies,
            label: 'Próximamente',
            subLabel: 'En este mes',
            loadNextPage: () => ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
          ),

          MovieHorizontalListview(
            movies: popularMovies,
            label: 'Populares',
            subLabel: 'Recientemente',
            loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}