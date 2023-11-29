import 'package:cinemapedia/infraestructure/models/moviedb/movie_details.dart';
import 'package:dio/dio.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/movie_response.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class MoviedbDatasource extends MoviesDatasource {
  
  //> Configuro la consumicion de la api
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDBKey,
        'language': 'es-UY',
      },
    ),
  );

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    
    //> Transformo el resultado en un objeto MovieDbResponse (response.data sera un string con formato json)
    final MovieDbResponse movieDBResponse = MovieDbResponse.fromJson(json);

    //> Una vez que tengo el response transformado a un objeto MovieDbResponse, transformo el result
    //> que es una lista de MoviemovieDB a una lista de Movie a traves del MovieMapper
    //> que recibe un MovieMovieDB y lo Transforma a un Movie
    final List<Movie> movies = movieDBResponse.results
        .where((movieMovieDB) => movieMovieDB.posterPath !='no-poster') //> Aca filtro las peliculas que no tienen poster
        .map((movieMovieDB) => MovieMapper.movieDBToEntity(movieMovieDB))
        .toList();

    return movies;
  }

  // Implementacion de getNowPlaying
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    
    //> Obtengo la respuesta de la api
    final response = await dio.get('/movie/now_playing', queryParameters: {'page': page});
    
    return _jsonToMovies(response.data);
  }

  // Implementacion de getPopular
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    
    //> Obtengo la respuesta de la api
    final response = await dio.get('/movie/popular', queryParameters: {'page': page});

    return _jsonToMovies(response.data);
  }
  
  // Implementacion de getUpcoming
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    
    //> Obtengo la respuesta de la api
    final response = await dio.get('/movie/upcoming', queryParameters: {'page': page});

    return _jsonToMovies(response.data);
  }

  // Implementacion de getTopRated
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    
    //> Obtengo la respuesta de la api
    final response = await dio.get('/movie/top_rated', queryParameters: {'page': page});

    return _jsonToMovies(response.data);
  }
  
  @override
  Future<Movie> getMovieById(String id) async {
    
    //> Obtengo la respuesta de la api
    final response = await dio.get('/movie/$id');
    if (response.statusCode != 200) throw Exception('Movie with $id not found');

    final moviDetails = MovieDetails.fromJson(response.data);

    final Movie movie = MovieMapper.movieDetailsToEntity(moviDetails);

    return movie;

  }
  
}