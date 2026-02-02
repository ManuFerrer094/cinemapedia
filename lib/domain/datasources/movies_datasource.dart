import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MoviesDatasource {  
  Future<List<Movie>> getNowPlaying({
    required int page,
  });
  
  Future<List<Movie>> getUpcoming({
    required int page,
  });

  Future<List<Movie>> getPopular({
    required int page,
  });
}