import 'package:cinemapedia/main.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavouriteView extends ConsumerStatefulWidget {
  const FavouriteView({super.key});

  @override
  FavouriteViewState createState() => FavouriteViewState();
}

class FavouriteViewState extends ConsumerState<FavouriteView> {
  bool isLoading = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

    loadNexPage();
  }

  void loadNexPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;

    final movies =
        await ref.read(favoritesMoviesProvider.notifier).loadNexPage();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesMovies = ref.watch(favoritesMoviesProvider).values.toList();

    if (favoritesMovies.isEmpty) {
      final colors = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.heart_broken_outlined, size: 60, color: colors.primary),
            Text('Ohh no',style: TextStyle(fontSize: 30, color: colors.primary)),
            const Text('No tienes películas favoritas', style: TextStyle(fontSize: 20, color: Colors.black45),),
            const SizedBox(height: 20,),
            FilledButton.tonal(onPressed: () => context.go('/home/0'), 
            child: const Text('Empieza a buscar'))
          ],
        ),
      );
    }

    return Scaffold(
        body: MovieMasonry(
      loadNextPage: loadNexPage,
      movies: favoritesMovies,
    ));
  }
}
