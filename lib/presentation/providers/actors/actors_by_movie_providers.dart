import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* Yo quiero guardar en cache algo como esto
   Un mapa de {id: Movie} (<Actor[]> => es una lista de actores de la clas Actor)

  {
    '505642': <Actor[]>,
    '505643': <Actor[]>,
    '505264': <Actor[]>,
    '505689': <Actor[]>,
    '507548': <Actor[]>,   
  }

*/

final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {
  final actorRepository = ref.watch(actorRepositoryProvider);
  return ActorsByMovieNotifier(getActorByMovie: actorRepository.getActorByMovie);
});


typedef GetActorCallback = Future<List<Actor>> Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorCallback getActorByMovie;

  ActorsByMovieNotifier({required this.getActorByMovie}) : super({});

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;
    final actors = await getActorByMovie(movieId);

    state = {...state, movieId: actors};
  }
}