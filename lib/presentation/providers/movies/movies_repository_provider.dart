import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/config/infrastructure/repositories/movie_repository_impl.dart';
import 'package:cinemapedia/config/infrastructure/moviedb_datasource.dart';

final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(MoviedbDatasource());
});