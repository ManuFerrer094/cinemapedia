import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return AppBar(
      title: Row(
        children: [
          Icon(
            Icons.movie_outlined,
            color: colors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            'Cinemapedia',
            style: titleStyle,
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () async {
            final movieRepository = ref.read(movieRepositoryProvider);

            final Movie? movie = await showSearch<Movie?>(
              context: context,
              delegate: SearchMovieDelegate(searchMovies: movieRepository.searchMovies, initialMovies: [])
            );

            if ( movie != null ) {
              context.push('/movie/${movie.id}');
            }
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}