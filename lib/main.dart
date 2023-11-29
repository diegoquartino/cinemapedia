import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//> Paquete para las variables de entorno
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  
  
  setPathUrlStrategy();

  //> Para leer las variables de entorno
  await dotenv.load(fileName: ".env");

  //> Envolvemos MyApp() dentro de un ProviderScope que es quien tendra la referencia (ref)
  //> a todos nuestros providers de riverpod
  runApp(
    const ProviderScope(child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scrollBehavior: MyCustomScrollBehavior(),
      routerConfig: appRouter,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),      
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}