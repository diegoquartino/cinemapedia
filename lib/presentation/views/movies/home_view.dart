import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();

    // Inicializo o cargo las primeras peliculas
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    
    final initialLoading = ref.watch(initialLoadingProvider);

    if (initialLoading) return const FullScreenLoader();

    final nowPLayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final slideshowMovies = ref.watch(moviesSlideShowProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),     
            titlePadding: EdgeInsets.zero,       
          ),
        ),
        SliverList(          
          delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (context, index) {
              return Column(                
                children: [
                  MoviesSlideshow(movies: slideshowMovies),

                  MovieHorizontalListview(
                    movies: nowPLayingMovies,
                    title: 'En cines',
                    subTitle: 'Lunes 20',
                    loadNextPage: () => ref
                        .read(nowPlayingMoviesProvider.notifier)
                        .loadNextPage()
                  ),

                  MovieHorizontalListview(
                    movies: upcomingMovies,
                    title: 'Proximamente',
                    subTitle: 'En este mes',
                    loadNextPage: () => ref
                        .read(upcomingMoviesProvider.notifier)
                        .loadNextPage(),
                  ),

                  MovieHorizontalListview(
                    movies: popularMovies,
                    title: 'Populares',
                    //subTitle: '',
                    loadNextPage: () => ref
                        .read(popularMoviesProvider.notifier)
                        .loadNextPage(),
                  ),

                  MovieHorizontalListview(
                    movies: topRatedMovies,
                    title: 'Mejores calificadas',
                    subTitle: 'Desde el origen',
                    loadNextPage: () => ref
                        .read(topRatedMoviesProvider.notifier)
                        .loadNextPage(),
                  ),

                  //> Como se mostraba antes de agregar el SlideShow
                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: nowPLayingMovie.length,
                  //     itemBuilder: (context, index) {
                  //       final movie = nowPLayingMovie[index];
                  //       return ListTile(
                  //         title: Text(movie.title),
                  //       );
                  //     },
                  //   ),
                  // )
                ],
              );
            },
          ),
        )
      ],
    );
  }
}




