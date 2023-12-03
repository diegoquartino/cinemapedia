import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  
  final int currentIndex ;
  const CustomBottomNavigationBar({super.key, required this.currentIndex});


  void onItemTapped(BuildContext context, int index) {

    switch (index){
      case 0:
        context.go('/home/0');
        break;
      case 1:
        context.go('/home/1');
        break;
      case 2:
        context.go('/home/2');
        break;
      default:
        context.go('/home/0');
        break;
    }

  }

  @override
  Widget build(BuildContext context) {        
    // return NavigationBar(
    //   elevation: 0,
    //   selectedIndex: currentIndex,
    //   onDestinationSelected: (index) => onItemTapped(context, index),
    //   destinations: const [
    //     NavigationDestination(
    //       icon: Icon(Icons.home_max_outlined),
    //       label: 'Inicio',
    //     ),
    //     NavigationDestination(
    //       icon: Icon(Icons.label_outline),
    //       label: 'Pupolares',

    //     ),
    //     NavigationDestination(
    //       icon: Icon(Icons.favorite_outline),
    //       label: 'Favoritos',
    //     ),
    //   ],
    // );
    return BottomNavigationBar(     
      elevation: 0,
      currentIndex: currentIndex,
      onTap: (value) => onItemTapped(context, value),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
          activeIcon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_activity_outlined),
          label: 'Populares',
          activeIcon: Icon(Icons.local_activity_rounded),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favoritos',
          activeIcon: Icon(Icons.favorite),

        ),
      ],
    );
  }
}
