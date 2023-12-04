import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/config/helpers/humman_formats.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegates extends SearchDelegate<Movie?> {
  /// Funcion de callback que realizará la busqueda
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  SearchMovieDelegates({
    required this.initialMovies,
    required this.searchMovies,
  });

  //> Esta funcion es para eliminar el stream, ya que cada vez que abrimos la pantalla de busqueda se crear un
  //> StreamBuilder pero al cerrar este sigue en memoria, entonces la idea es cerrarlo cada vez que se
  //> cierre la pantalla de busqueda
  void clearStreams() {
    debouncedMovies.close();
    isLoadingStream.close();
  }

  //> Funcion manual para el debaunce, esto lo que hace es generar un timer que dura X milisegundos
  //> sise vuelve a ingresar a la funcion antes de los 500 milisegundos y el timer esta activo
  //> lo cancela y lo vuelve a generar (en otras palabras lo "reinicia")
  void _onQueryChanged(String query) {
    
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 600), () async {
      //> Resolvimos la insercion de elementos vacios en el 'searchMovies' del datasource
      //> moviedb_datasource.dart
      // if (query.isEmpty) {
      //   debouncedMovies.add([]);
      //   return;
      // }

      final movies = await searchMovies(query);
      if (!debouncedMovies.isClosed) {
        debouncedMovies.add(movies);
        initialMovies = movies;
        isLoadingStream.add(false);
      }
    });
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _MovieItem(
                movie: movies[index],
                onMovieSelected: (context, movie) {
                  clearStreams();
                  close(context, movie);
                });
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'Buscar Pelicula';

  //> Para las acciones, por ejemplo del boton de busqueda
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.refresh_rounded),
              ),
            );
          }

          return FadeIn(
            animate: query.isNotEmpty,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.clear),
            ),
          );
        },
      ),
    ];
  }

  //> Para agrega algo al principio como un icono u otra cosa
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  //> El resultado que va a devolver cuando el usuario de enter
  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  //> Para saber que es lo que quiero hacer cuando la persona esta escribiendo
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);

    return buildResultsAndSuggestions();

    // return FutureBuilder( //> se cambia por un StreamBuilder para evitar que cada cambio haga una consumicion a la api
    //   future: searchMovies(query),
    //   builder: (context, snapshot) {
    //     final movies = snapshot.data ?? [];

    //     return ListView.builder(
    //       itemCount: movies.length,
    //       itemBuilder: (context, index) {
    //         return _MovieItem(
    //           movie: movies[index],
    //           onMovieSelected: close, //> tambien se podria definir como '(context, movie) => close(context, movies[index])'
    //         );
    //       },
    //     );
    //   },
    // );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                    height: 130,
                    fit: BoxFit.cover,
                    image: NetworkImage(movie.posterPath != 'no-poster'
                       ? movie.posterPath
                       : Environment.noPosterMovieImage,),
                    placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
                  )
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyle.titleMedium),
                  (movie.overview.length > 100)
                      ? Text('${movie.overview.substring(0, 100)}...')
                      : Text(movie.overview),
                  Row(
                    children: [
                      Icon(
                        Icons.star_half_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1),
                        style: textStyle.bodyMedium!
                            .copyWith(color: Colors.yellow.shade900),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
