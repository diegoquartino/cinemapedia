import 'package:cinemapedia/config/helpers/humman_formats.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import '../../providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
    ref.read(similarMoviesProvider.notifier).loadNextPage(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return Scaffold(
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/loaders/bottle-loader.gif'),
        ],
      )
          // Center(
          //   child: CircularProgressIndicator(
          //     strokeWidth: 2,
          //   ),
          // ),
          );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppbar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie),
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      movie.posterPath,
                      width: size.width * 0.3,
                    ),
                  ),
                  SizedBox(
                  //> Envolvemos en SizedBox para que tenga un ancho fijo y funcione el spacer dentro del Row
                  width: size.width * 0.3,
                  child: Row(
                    children: [
                      Icon(Icons.star_half_outlined,
                          color: Colors.yellow.shade800),
                      const SizedBox(width: 3),
                      Text('${movie.voteAverage}',
                          style: textStyle.bodyMedium
                              ?.copyWith(color: Colors.yellow.shade800)),
                      const Spacer(),
                      Text(
                        HumanFormats.number(movie.popularity),
                        style: textStyle.bodySmall,
                      )
                    ],
                  ),
                )
                ],
              ),

              const SizedBox(width: 10),

              // Descripcion
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('#${movie.id}', style: textStyle.labelSmall),
                    movie.releaseDate != null
                        ? Text('Año: ${movie.releaseDate!.year.toString()}')
                        : const SizedBox(),
                    Text(movie.title, style: textStyle.titleLarge),
                    movie.originalTitle.isNotEmpty &&
                            movie.title.compareTo(movie.originalTitle) != 0
                        ? Text(movie.originalTitle,
                            style: textStyle.titleMedium)
                        : const SizedBox(),
                    Text(movie.overview),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Generos de la pelicula
        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                ...movie.genreIds.map(
                  (gender) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                      label: Text(gender),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Actores de la pelicula
        ActorsByMovie(movieId: movie.id.toString()),

        const SizedBox(height: 30),

        _SimilarMovies(movieId: movie.id.toString()),

        const SizedBox(height: 30)
      ],
    );
  }
}

class _SimilarMovies extends ConsumerWidget {
  final String movieId;
  const _SimilarMovies({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final similarMovies = ref.watch(similarMoviesProvider);

    if (similarMovies.isEmpty) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }

    return MovieHorizontalListview(
        movies: similarMovies,
        title: 'Similares',
        loadNextPage: () =>
            ref.read(similarMoviesProvider.notifier).loadNextPage(movieId));
  }
}



//> FutureProviderFamily<bool, int> el tipo de isFavoriteProvider, significa que va a devolver un bool
//> y que necesita como parametro un int
final isFavoriteProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});

class _CustomSliverAppbar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppbar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            //> si no pongo el await y toco muchas veces el boton de favorito
            //> me pasa que no siempre se cambia el icono y es porqueel invalidate se llama antes
            //> de que termine el toogleFavorite entonces no se entera del cambio de valor
            //await ref.read( localStorageRepositoryProvider ).toggleFavorite(movie); //> Ya no llamos mas a esta funcion del local storage repository

            //> ahora llamo a la funcion que quita y agrega de favoritos, del favoritesMoviesProvider
            await ref
                .read(favoritesMoviesProvider.notifier)
                .toggleFavorite(movie);

            ref.invalidate(isFavoriteProvider(movie.id));
          },
          icon: isFavoriteFuture.when(
            loading: () => const CircularProgressIndicator(
              strokeWidth: 2,
            ),
            data: (isFavorite) => isFavorite
                ? const Icon(
                    Icons.favorite_rounded,
                    color: Colors.red,
                  )
                : const Icon(Icons.favorite_border),
            error: (_, __) => throw UnimplementedError(),
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 0),
        title: _CustomGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Colors.transparent,
            Colors.black87,
          ],
          stops: const [0.7, 1.0],
        ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
              ),
            ),
            _CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [
                Colors.transparent,
                Colors.black87,
              ],
              stops: const [0.7, 1.0],
            ),
            _CustomGradient(
              begin: Alignment.topLeft,
              colors: const [
                Colors.black87,
                Colors.transparent,
              ],
              stops: const [0.0, 0.2],
            ),
            _CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.centerLeft,
              colors: const [
                Colors.black54,
                Colors.transparent,
              ],
              stops: const [0.0, 0.2],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<Color> colors;
  final List<double> stops;

  const _CustomGradient({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    required this.colors,
    required this.stops,
  }) : assert(colors.length == stops.length,
            'La cantidad de colores debe ser igual a la cantidad de stops');

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            colors: colors,
            stops: stops,
          ),
        ),
      ),
    );
  }
}
