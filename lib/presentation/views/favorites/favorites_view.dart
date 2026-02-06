import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLoading = false;
  bool isLastPage = false;

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    
    isLoading = true;
    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    
    isLoading = false;
    
    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMoviesMap = ref.watch(favoriteMoviesProvider);
    final favoriteMovies = favoriteMoviesMap.values.toList();

    if (favoriteMovies.isEmpty) {
      final colors = Theme.of(context).colorScheme;
      return CustomScrollView(
        slivers: [
          const CustomBackAppBar(
            title: 'Favoritos',
          ),
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_outline,
                    size: 60,
                    color: colors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ohhh no!!',
                    style: TextStyle(fontSize: 30, color: colors.primary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'No tienes favoritos aún',
                    style: TextStyle(fontSize: 20, color: Colors.black45),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.tonal(
                    onPressed: () => context.go('/'),
                    child: const Text('Empieza a buscar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return CustomScrollView(
      slivers: [
        const CustomBackAppBar(
          title: 'Favoritos',
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final movie = favoriteMovies[index];
                return _MoviePoster(movie: movie);
              },
              childCount: favoriteMovies.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final movie;

  const _MoviePoster({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          movie.posterPath,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress != null) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            return child;
          },
        ),
      ),
    );
  }
}
