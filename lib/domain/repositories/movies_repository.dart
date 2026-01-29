import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MovieRepository {  
  Future<List<Movie>> getNowPlaying({
    required int page,
  });
}