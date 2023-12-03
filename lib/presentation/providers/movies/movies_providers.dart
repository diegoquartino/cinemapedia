import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


//* Provider de las peliculas en cine
//> Es un proveedor de un estado que notifica su cambio
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  
  //> Obtengo la referencia (en otro lenguaje seria el AddresOf) a la funcion getNowPlaying
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;

  //> Le paso al constructor de 'MoviesNotifier' la funcion de callback
  //> que es la referencia a la funcion que obtuvimos
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});


//* Provider de las peliculas populares
final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {  
  
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;
  
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);  
  
});

//* Provider de las peliculas populares
final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {  
  
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

//* Provider de las peliculas populares
final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {  
  
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

//* Provider de las peliculas similares
final similarMoviesProvider = StateNotifierProvider<MoviesByActorNotifier, List<Movie>>((ref) {  
  
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getSimilars;
  return MoviesByActorNotifier(fetchMoreMovies: fetchMoreMovies);
});



//* Notifier para peliculas
//> Defino un tipo de datos que en este caso es una funcion que
//> dada una pagina 'page' devuelve una lista de 'Movie'
//> NOTA: 'typedef MovieCallback' no es una funcion sino un TIPO DE DATO!!!
typedef MovieCallback = Future<List<Movie>> Function({int page});

//> StateNotifier<List<Movie>> donde List<Movie> es el tipo de datos
//> que tendrá la variable 'state'
class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  MovieCallback fetchMoreMovies;  
  //> Variable para que si se esta mientras este cargando no vuelva a cargar
  bool isLoading = false; 

  //> Al constructor le decimos que vamos a recibir un parametro
  //> con el tipo de dato 'MovieCallback'
  //> Inicializo el estado con una lista vacia 'super([])'
  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<List<Movie>> loadNextPage() async {
    
    if (isLoading) return [];
    isLoading = true;
    currentPage++;

    //> utilizo la funcion de callbak, al utilizar fetchMoreMovies estoy lamando
    //> a la funcion 'getNowPlaying' ya que fetchMoreMovies es una referencia de ella
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);

    //> Como state es de tipo List<Movie> modifico el state con una nueva lista
    //> que contiene lo que habia en state mas lo que se obtuvo en 'movies'
    state = [...state, ...movies];
    isLoading = false;
    return movies;
  }
}


//* Notifier para peliculas similares
typedef GetMoviesByActorCallback = Future<List<Movie>> Function(String id, {int page});

class MoviesByActorNotifier extends StateNotifier<List<Movie>> {
  
  final GetMoviesByActorCallback fetchMoreMovies;
  MoviesByActorNotifier({required this.fetchMoreMovies}) : super([]);

  int currentPage = 0;
  bool isLoading = false; 

  Future<List<Movie>> loadNextPage(String movieId) async {
    if (isLoading) return [];
    isLoading = true;
    currentPage++;

    //> utilizo la funcion de callbak, al utilizar fetchMoreMovies estoy lamando
    //> a la funcion 'getNowPlaying' ya que fetchMoreMovies es una referencia de ella
    final List<Movie> movies = await fetchMoreMovies(movieId, page: currentPage);

    //> Como state es de tipo List<Movie> modifico el state con una nueva lista
    //> que contiene lo que habia en state mas lo que se obtuvo en 'movies'
    state = [...state, ...movies];
    isLoading = false;
    return movies;
  }
}