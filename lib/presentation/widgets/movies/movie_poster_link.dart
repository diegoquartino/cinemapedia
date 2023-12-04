import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviePosterLink extends StatelessWidget {
  final Movie movie;

  const MoviePosterLink({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 900),
      child: GestureDetector(
        onTap: () => context.push('/home/0/movie/${movie.id}'),
        child: SizedBox(
          height: 250,
          child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FadeInImage(
            height: 180,
            fit: BoxFit.cover,
            placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
            image: NetworkImage(movie.posterPath),
          ),
        ),
        ),
      ),
    );
  }
}
