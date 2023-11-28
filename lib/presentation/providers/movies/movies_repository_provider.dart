import 'package:cinemapedia/infraestructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infraestructure/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Este repositorio "Provider" es inmutable (solo lectura)
final movieRepositoryProvider =
    Provider((ref) => MovieRepositoryImpl(MoviedbDatasource()));
