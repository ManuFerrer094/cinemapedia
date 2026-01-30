import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return AppBar(
      title: Row(
        children: [
          Icon(
            Icons.movie_outlined,
            color: colors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            'Cinemapedia',
            style: titleStyle,
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}