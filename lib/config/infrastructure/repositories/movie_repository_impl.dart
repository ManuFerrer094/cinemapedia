import 'package:cinemapedia/config/infrastructure/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MoviesRepository {

  final MoviesDatasource datasource;
  MovieRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlaying({required int page}) {
    return datasource.getNowPlaying(page: page);
  }
  
}