import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MovieHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String? label;
  final String? subLabel;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview({
    super.key,
    required this.movies,
    this.label,
    this.subLabel,
    this.loadNextPage,
  });

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
        if (widget.loadNextPage != null) widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    const double baseImageWidth = 130;
    const double baseImageHeight = 170;
    final double imageWidth = (baseImageWidth * 4) / 3;
    final double imageHeight = (baseImageHeight * 4) / 3;

    const double titleHeight = 40;

    return SizedBox(
      height: imageHeight + 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.label!, style: Theme.of(context).textTheme.titleMedium),
                  if (widget.subLabel != null)
                    Text(widget.subLabel!, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (context, index) {
                final movie = widget.movies[index];

                return Container(
                  width: imageWidth,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          movie.backdropPath,
                          width: imageWidth,
                          height: imageHeight,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: imageWidth,
                              height: imageHeight,
                              color: colors.surfaceVariant,
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: imageWidth,
                            height: imageHeight,
                            color: colors.surfaceVariant,
                            child: Icon(Icons.movie_outlined, color: colors.onSurfaceVariant, size: 40),
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      SizedBox(
                        height: titleHeight,
                        child: Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                _StarRating(value: movie.voteAverage / 10, size: 16, color: colors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  movie.voteAverage.toStringAsFixed(1),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          Text('Votos:' +
                            HumanFormats.number(movie.voteCount.toDouble()),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final double value;
  final double size;
  final Color color;

  const _StarRating({required this.value, this.size = 16, required this.color});

  @override
  Widget build(BuildContext context) {
    final fill = value.clamp(0.0, 1.0);
    return Stack(
      children: [
        Icon(Icons.star_border, size: size, color: Colors.grey.shade400),
        ClipRect(
          clipper: _StarClipper(width: size * fill),
          child: Icon(Icons.star, size: size, color: color),
        ),
      ],
    );
  }
}

class _StarClipper extends CustomClipper<Rect> {
  final double width;
  _StarClipper({required this.width});

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, width, size.height);

  @override
  bool shouldReclip(covariant _StarClipper oldClipper) => oldClipper.width != width;
}