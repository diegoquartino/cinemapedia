import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MoviesRepository {

  // Obtencion de peliculas
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getPopular({int page = 1});

  Future<List<Movie>> getUpcoming({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<Movie> getMovieById(String id);


  //Busqueda de peliculas
  Future<List<Movie>> searchMovies(String query);

}
