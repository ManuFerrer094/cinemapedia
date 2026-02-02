import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MoviesRepository {  
  Future<List<Movie>> getNowPlaying({
    required int page,
  });
  
  Future<List<Movie>> getUpcoming({
    required int page,
  });
}