

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


//> Es un proveedor de un estado que notifica su cambio
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  
  //> Obtengo la referencia (en otro lenguaje seria el AddresOf) a la funcion getNowPlaying
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getNowPlaying;

  //> Le paso al constructor de 'MoviesNotifier' la funcion de callback
  //> que es la referencia a la funcion que obtuvimos
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});


//> Defino un tipo de datos que en este caso es una funcion que 
//> dada una pagina 'page' devuelve una lista de 'Movie'
//> NOTA: 'typedef MovieCallback' no es una funcion sino un TIPO DE DATO!!!
typedef MovieCallback = Future<List<Movie>> Function({int page});

//> StateNotifier<List<Movie>> donde List<Movie> es el tipo de datos 
//> que tendrá la variable 'state'
class MoviesNotifier extends StateNotifier<List<Movie>> {

  int currentPage = 0;
  MovieCallback fetchMoreMovies;

  //> Al constructor le decimos que vamos a recibir un parametro
  //> con el tipo de dato 'MovieCallback'
  MoviesNotifier({
    required this.fetchMoreMovies
  }):super([]);

  Future<void> loadNextPage() async {
    currentPage++;

    //> utilizo la funcion de callbak, al utilizar fetchMoreMovies estoy lamando 
    //> a la funcion 'getNowPlaying' ya que fetchMoreMovies es una referencia de ella
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    
    //> Como state es de tipo List<Movie> modifico el state con una nueva lista 
    //> que contiene lo que habia en state mas lo que se obtuvo en 'movies'
    state = [...state,...movies];
  }

}