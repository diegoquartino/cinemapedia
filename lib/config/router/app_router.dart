import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

//> El ChildRoutes se hace para que funcione en chrome, esto es porque cuando entramos a la pantalla
//> aparece el boton para volver atras pero si recargamos la misma este desaparece, lo mismo pasa
//> si entramos directo al link a traves de un enlace este booton no se veria

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'movie/:id',
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';
            return MovieScreen(movieId: movieId);
          },
        ),
      ],
    ),
  ],
);
