import 'package:flutter/material.dart';

typedef OnNavTap = void Function(int index);

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final OnNavTap? onTap;

  const CustomBottomNavigation({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.onSurfaceVariant,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max_outlined),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          label: 'Categorías',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Favoritos',
        ),
      ],
    );
  }
}
