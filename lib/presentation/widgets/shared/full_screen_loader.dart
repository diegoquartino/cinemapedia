import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = <String>[
      'Cargando peliculas',
      'Comprando palomitas de maíz',
      'Cargando populares',
      'Cargando peliculas próximas',
      'Cargando top rated',
      'Cargando lo que falta',
      'Esto esta demorando che! :/',
    ];

    Stream<String> getLoadingMessages() {
      return Stream.periodic(const Duration(milliseconds: 1200), (step) {
        return messages[step];
      }).take(messages.length);
    }
      
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Espere por favor'),
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Cargando...');

              return Text(snapshot.data!);
            },
          )
        ],
      ),
    );
  }
}
