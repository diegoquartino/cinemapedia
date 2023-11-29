import 'package:dio/dio.dart';
import 'package:cinemapedia/infraestructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/credits_response.dart';
import 'package:cinemapedia/config/constants/environment.dart';

import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';

class ActorMovieDbDataSource extends ActorsDatasource {
  
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDBKey,
        'language': 'es-UY',
      },
    ),
  );

  //> Funcion que recibe el json string y lo transforma a un actor
  List<Actor> _jsonToActor(Map<String, dynamic> json) {
    
    final CreditsResponse actorDBResponse = CreditsResponse.fromJson(json);

    final List<Actor> movies = actorDBResponse.cast
        .map((actorMovieDB) => ActorMapper.castToEntity(actorMovieDB))
        .toList();

    return movies;
  }

  @override
  Future<List<Actor>> getActorByMovie(String movieId) async {

    final response = await dio.get('/movie/$movieId/credits'); 

    return _jsonToActor(response.data);
  }
}
