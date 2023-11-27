import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {        
    return NavigationBar(
      elevation: 0,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_max_outlined),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.label_outline),
          label: 'Categorías',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_outline),
          label: 'Favoritos',
        ),
      ],
    );
    // return BottomNavigationBar(     
    //   elevation: 0,
    //   items: const [
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.home),
    //       label: 'Home',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.label_outline),
    //       label: 'Categorias',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.favorite_outline),
    //       label: 'Favoritos',
    //     ),
    //   ],

    // );
  }
}
