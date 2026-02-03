import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/responsive_helper.dart';

import 'package:cinemapedia/domain/entities/movie.dart';

import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_by_movie_provider.dart';


class MovieScreen extends ConsumerStatefulWidget {

  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({
    super.key, 
    required this.movieId
  });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();
    
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);

  }

  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch( movieInfoProvider )[widget.movieId];

    if ( movie == null ) {
      return const Scaffold(body: Center( child: CircularProgressIndicator( strokeWidth: 2)));
    }


    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(movie: movie),
            childCount: 1
          ))
        ],
      ),
    );
  }
}


class _MovieDetails extends StatelessWidget {
  
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // Imagen
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: ResponsiveHelper.isDesktop() ? 300 : size.width * 0.3,
                ),
              ),

              const SizedBox( width: 10 ),

              // Descripción
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( movie.title, style: textStyles.titleLarge ),
                    const SizedBox(height: 10),
                    Text( 
                      movie.overview,
                      style: textStyles.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              )

            ],
          ),
        ),

        
        // Generos de la película
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                margin: const EdgeInsets.only( right: 10),
                child: Chip(
                  label: Text( gender ),
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20)),
                ),
              ))
            ],
          ),
        ),

        _ActorsByMovie(movieId: movie.id.toString() ),

        const SizedBox(height: 50 ),
      ],
    );
  }
}


class _ActorsByMovie extends ConsumerStatefulWidget {

  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  ConsumerState<_ActorsByMovie> createState() => _ActorsByMovieState();
}

class _ActorsByMovieState extends ConsumerState<_ActorsByMovie> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollHorizontal(double delta) {
    final currentPosition = _scrollController.position.pixels;
    final newPosition = (currentPosition + delta).clamp(
      0.0, 
      _scrollController.position.maxScrollExtent
    );
    
    _scrollController.animateTo(
      newPosition,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      const scrollAmount = 200.0;
      
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowLeft:
          _scrollHorizontal(-scrollAmount);
          return true;
        case LogicalKeyboardKey.arrowRight:
          _scrollHorizontal(scrollAmount);
          return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    final actorsByMovie = ref.watch( actorsByMovieProvider );
    final isDesktop = ResponsiveHelper.isDesktop();

    if ( actorsByMovie[widget.movieId] == null ) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }
    final actors = actorsByMovie[widget.movieId]!;

    final actorListView = ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: actors.length,
      itemBuilder: (context, index) {
        final actor = actors[index];
        final actorWidth = isDesktop ? 160.0 : 135.0;

        return Container(
          padding: const EdgeInsets.all(8.0),
          width: actorWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Actor Photo
              FadeInRight(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    actor.profilePath,
                      height: isDesktop ? 200 : 180,
                      width: actorWidth,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Nombre
                const SizedBox(height: 5,),

                Text(actor.name, maxLines: 2 ),
                Text(actor.character ?? '', 
                  maxLines: 2,
                  style: const TextStyle( fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis ),
                ),

              ],
            ),
          );


        },
      );

    return SizedBox(
      height: isDesktop ? 320 : 300,
      child: isDesktop 
        ? Focus(
            focusNode: _focusNode,
            onKeyEvent: (node, event) {
              return _handleKeyEvent(event) 
                ? KeyEventResult.handled 
                : KeyEventResult.ignored;
            },
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final scrollDelta = event.scrollDelta.dy;
                  _scrollHorizontal(scrollDelta * 1.5);
                }
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.grab,
                onEnter: (_) {
                  if (!_focusNode.hasFocus) {
                    _focusNode.requestFocus();
                  }
                },
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: actorListView,
                ),
              ),
            ),
          )
        : actorListView,
    );

  }
}





class _CustomSliverAppBar extends StatelessWidget {

  final Movie movie;

  const _CustomSliverAppBar({
    required this.movie
  });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // title: Text( 
        //   movie.title,
        //   style: const TextStyle(fontSize: 20),
        //   textAlign: TextAlign.start,
        // ),
        background: Stack(
          children: [

            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if ( loadingProgress != null ) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),

            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.7, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black87
                    ]
                  )
                )
              ),
            ),

            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    stops: [0.0, 0.3],
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                    ]
                  )
                )
              ),
            ),



          ],
        ),
      ),
    );
  }
}