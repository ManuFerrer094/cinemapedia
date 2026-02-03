import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MoviesRepository {

  final MoviesDatasource datasource;
  MovieRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlaying({required int page}) {
    return datasource.getNowPlaying(page: page);
  }
  
  @override
  Future<List<Movie>> getUpcoming({required int page}) {
    return datasource.getUpcoming(page: page);
  }

  @override
  Future<List<Movie>> getPopular({required int page}) {
    return datasource.getPopular(page: page);
  }

  @override
  Future<Movie> getMovieById(String id) {
    return datasource.getMovieById(id);
  }
  
}