import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/responsive_helper.dart';


class MoviesSlideshow extends ConsumerStatefulWidget {
  final List<Movie> movies;
  
  const MoviesSlideshow({
    super.key,
    required this.movies,
  });

  @override
  ConsumerState<MoviesSlideshow> createState() => _MoviesSlideshowState();
}

class _MoviesSlideshowState extends ConsumerState<MoviesSlideshow> {
  @override
  void initState() {
    super.initState();

    if (widget.movies.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(moviesSlideshowProvider.notifier).setMovies(widget.movies);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final slideshowState = ref.watch(moviesSlideshowProvider);
    final movies = slideshowState.movies.isEmpty ? widget.movies : slideshowState.movies;
    final currentPage = slideshowState.currentPage;
    final isDesktop = ResponsiveHelper.isDesktop();
    
    if (movies.isEmpty) {
      return SizedBox(
        height: isDesktop ? 300 : 250,
        child: Center(
          child: CircularProgressIndicator(
            color: colors.primary,
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: isDesktop ? 280 : 220, // Mayor altura en desktop
          child: Swiper(
            itemCount: movies.length,
            autoplay: true,
            autoplayDelay: 3000,
            viewportFraction: isDesktop ? 0.7 : 0.86, // Diferente fracción para desktop
            onIndexChanged: (index) {
              ref.read(moviesSlideshowProvider.notifier).setCurrentPage(index);
            },
            itemBuilder: (context, index) {
          final movie = movies[index];
          final distanceFromCenter = (currentPage - index).abs().toDouble();
          final scale = 1.0 - (distanceFromCenter * 0.1).clamp(0.0, 0.1);
          
          return Transform.scale(
            scale: scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Poster image
                    FadeIn(
                      duration: const Duration(milliseconds: 600),
                      child: Image.network(
                        movie.backdropPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: colors.surfaceContainerHighest,
                            child: Icon(
                              Icons.movie_outlined,
                              size: 50,
                              color: colors.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    
                    // Movie info
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
        },
        ),
        ),

        const SizedBox(height: 10),

        // External paginator (dots) below the carousel
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(movies.length, (i) {
            final isActive = i == currentPage;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 10 : 8,
              height: isActive ? 10 : 8,
              decoration: BoxDecoration(
                color: isActive ? colors.primary : colors.secondary,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }
}