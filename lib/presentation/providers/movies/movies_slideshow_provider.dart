import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';
import 'movies_providers.dart';



final moviesSlideShowProvider = Provider<List<Movie>>((ref) {

  final nowPLayingMovie = ref.watch(nowPlayingMoviesProvider);

  if (nowPLayingMovie.isEmpty) return [];

  return nowPLayingMovie.sublist(0,6);

});