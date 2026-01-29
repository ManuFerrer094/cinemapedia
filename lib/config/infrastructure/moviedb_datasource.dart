import 'package:cinemapedia/config/infrastructure/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:dio/dio.dart';
import 'package:cinemapedia/config/constants/environment.dart';

class MoviedbDatasource extends MoviesDatasource {

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-ES',
      },
    ),
  );

  @override
  Future<List<Movie>> getNowPlaying({required int page}) async {
    final response = await dio.get('/movie/now_playing');
    final List<Movie> movies = [];
    
    return movies;
  }
}