import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  int getCurrentIndex(BuildContext context) {
    
    final String location = GoRouterState.of(context).matchedLocation;

    switch (location) {
      case '/':
        return 0;

      case '/categories':
        return 1;

      case '/favourites':
        return 2;

      default:
        return 0;
    }
  }

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/categories');
        break;
      case 2:
        context.go('/favourites');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      elevation: 0,
      onDestinationSelected: (optionIndex) => onItemTapped(context, optionIndex),
      selectedIndex: getCurrentIndex(context),
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
    //       icon: Icon(Icons.home_max_outlined),
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
    //  );
  }
}
