



import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';

class ActorRepositoryImpl {
  final ActorsDatasource actorsDatasource;

  ActorRepositoryImpl(this.actorsDatasource);

  Future<List<Actor>> getActorsByMovie(String movieId) {
    return actorsDatasource.getActorsByMovie(movieId);
  }
}