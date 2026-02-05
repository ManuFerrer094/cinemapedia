import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
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
    final response = await dio.get('/movie/now_playing', queryParameters: {'page': page});

    final movieDBResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies = movieDBResponse.results
    .where((moviedb) => moviedb.posterPath != 'no-poster' || moviedb.backdropPath != 'no-poster')
    .map((moviedb) => 
      MovieMapper.movieDBToEntity(moviedb)
    ).toList();
    
    return movies;
  }
  
  @override
  Future<List<Movie>> getUpcoming({required int page}) async {
    final response = await dio.get('/movie/upcoming', queryParameters: {'page': page});

    final movieDBResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies = movieDBResponse.results
    .where((moviedb) => moviedb.posterPath != 'no-poster' || moviedb.backdropPath != 'no-poster')
    .map((moviedb) => 
      MovieMapper.movieDBToEntity(moviedb)
    ).toList();
    
    return movies;
  }

  @override
  Future<List<Movie>> getPopular({required int page}) async {
    final response = await dio.get('/movie/popular', queryParameters: {'page': page});

    final movieDBResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies = movieDBResponse.results
    .where((moviedb) => moviedb.posterPath != 'no-poster' || moviedb.backdropPath != 'no-poster')
    .map((moviedb) => 
      MovieMapper.movieDBToEntity(moviedb)
    ).toList();
    
    return movies;
  }
  
  @override
  Future<Movie> getMovieById(String id) async {

    final response = await dio.get('/movie/$id');
    if (response.statusCode != 200) {
      throw Exception('Movie with id: $id not found');
    }
    final movieDBDetails = MovieDetails.fromJson(response.data);
    final movie = MovieMapper.movieDetailsToEntity(movieDBDetails);

    return movie;
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) async{
    final response = await dio.get('/search/movie', queryParameters: {'query': query});
    final movieDBResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies = movieDBResponse.results
    .map((moviedb) => 
      MovieMapper.movieDBToEntity(moviedb)
    ).toList();
    
    return movies;
  }
}