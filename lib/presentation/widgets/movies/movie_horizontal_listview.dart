import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/config/helpers/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:go_router/go_router.dart';


class MovieHorizontalListview extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview({
    super.key,
    required this.movies,
    this.title, 
    this.subTitle,
    this.loadNextPage
  });

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {

  final scrollController = ScrollController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    
    scrollController.addListener(() {
      if ( widget.loadNextPage == null ) return;

      if ( (scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent ) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _scrollHorizontal(double delta) {
    final currentPosition = scrollController.position.pixels;
    final newPosition = (currentPosition + delta).clamp(
      0.0, 
      scrollController.position.maxScrollExtent
    );
    
    scrollController.animateTo(
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
    final isDesktop = ResponsiveHelper.isDesktop();
    
    final listView = ListView.builder(
      controller: scrollController,
      itemCount: widget.movies.length,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return FadeInRight(child: _Slide(movie: widget.movies[index]));
      },
    );

    return SizedBox(
      height: isDesktop ? 420 : 350,
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(title: widget.title, subTitle: widget.subTitle),

          Expanded(
            child: isDesktop
              ? Focus(
                  focusNode: focusNode,
                  onKeyEvent: (node, event) {
                    return _handleKeyEvent(event) 
                      ? KeyEventResult.handled 
                      : KeyEventResult.ignored;
                  },
                  child: Listener(
                    onPointerSignal: (event) {
                      if (event is PointerScrollEvent) {
                        // Convertir scroll vertical en scroll horizontal
                        final scrollDelta = event.scrollDelta.dy;
                        _scrollHorizontal(scrollDelta * 1.5); // Sensibilidad ajustada
                      }
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.grab,
                      onEnter: (_) {
                        // Dar foco cuando el mouse entra para que funcionen las teclas
                        if (!focusNode.hasFocus) {
                          focusNode.requestFocus();
                        }
                      },
                      child: Scrollbar(
                        controller: scrollController,
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: listView,
                      ),
                    ),
                  ),
                )
              : listView,
          )
        ],
      ),
    );
  }
}


class _Slide extends StatelessWidget {

  final Movie movie;

  const _Slide({ required this.movie });

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;
    final isDesktop = ResponsiveHelper.isDesktop();
    
    // Tamaños responsivos
    final imageWidth = isDesktop ? 200.0 : 150.0;
    final imageHeight = isDesktop ? 280.0 : 225.0; // Reducido para evitar overflow
    final titleHeight = isDesktop ? 45.0 : 40.0;

    return Container(
      margin: const EdgeInsets.symmetric( horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          //* Imagen
          SizedBox(
            width: imageWidth,
            height: imageHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                width: imageWidth,
                loadingBuilder: (context, child, loadingProgress) {
                  if ( loadingProgress != null ) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2 )),
                    );
                  }
                  return GestureDetector(
                    onTap: () => context.push('/movie/${ movie.id }'),
                    child: FadeIn(child: child),
                  );
                  
                },
              ),
            ),
          ),

          const SizedBox(height: 5),

          //* Title
          SizedBox(
            width: imageWidth,
            height: titleHeight,
            child: Text(
              movie.title,
              maxLines: isDesktop ? 3 : 2,
              style: textStyles.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          //* Rating
          SizedBox(
            width: imageWidth,
            child: Row(
              children: [
                Icon( Icons.star_half_outlined, color: Colors.yellow.shade800 ),
                const SizedBox( width: 3 ),
                Text('${ movie.voteAverage }', style: textStyles.bodyMedium?.copyWith( color: Colors.yellow.shade800 )),
                const Spacer(),
                Expanded(
                  child: Text( 
                    HumanFormats.number(movie.popularity), 
                    style: textStyles.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  )
                ),
          
              ],
            ),
          )


        ],
      ),
    );
  }
}



class _Title extends StatelessWidget {

  final String? title;
  final String? subTitle;


  const _Title({ this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {

    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only( top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          
          if ( title != null )
            Text(title!, style: titleStyle ),
          
          const Spacer(),

          if ( subTitle != null )
            FilledButton.tonal(
              style: const ButtonStyle( visualDensity: VisualDensity.compact ),
              onPressed: (){}, 
              child: Text( subTitle! )
          )

        ],
      ),
    );
  }
}