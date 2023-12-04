import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              //Icon(Icons.movie_outlined, color: colors.primary),
              Image.asset(
                'assets/film.png',
                width: 23,
                height: 23,
              ),
              const SizedBox(width: 5),
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const RadialGradient(
                    center: Alignment.topLeft,
                    radius: 3.0,
                    colors: <Color>[
                      Colors.cyan,
                      Color.fromARGB(255, 170, 94, 251),                      
                      Color.fromARGB(255, 116, 59, 170),
                    ],
                    tileMode: TileMode.clamp,
                  ).createShader(bounds);
                },
                child: Text(
                  'Cinemapedia',
                  style: titleStyle,                  
                ),
              ),
              const Spacer(), //> Toma todo el espacio que pueda (en este caso impulsa el IconButton a la derecha)
              IconButton(
                //iconSize: 18,
                onPressed: () {
                  final searchMovies = ref.read(searchedMoviesProvider);
                  final searchQuery = ref.read(searchQueryProvider);

                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMovieDelegates(
                      initialMovies: searchMovies,
                      searchMovies: ref
                          .read(searchedMoviesProvider.notifier)
                          .searchMoviesByQuery,
                    ),
                  ).then((movieResult) {
                    if (movieResult == null) return;
                    context.go('/home/0/movie/${movieResult.id}');
                  });
                },
                icon: const Icon(Icons.search),
              ),
              IconButton(
                //iconSize: 18,
                onPressed: () {
                  //TODO: Hacer funcionalidad para personalizacion
                },
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
