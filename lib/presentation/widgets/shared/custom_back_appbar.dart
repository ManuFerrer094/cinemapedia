import 'package:flutter/material.dart';

class CustomBackAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onBackPressed;

  const CustomBackAppBar({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final canPop = Navigator.of(context).canPop();
    
    return SliverAppBar(
      title: Text(title),
      floating: true,
      backgroundColor: backgroundColor ?? colors.surfaceContainer,
      foregroundColor: foregroundColor ?? colors.onSurface,
      actions: actions,
      leading: onBackPressed != null || canPop
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (onBackPressed != null) {
                  onBackPressed!();
                } else if (canPop) {
                  Navigator.of(context).pop();
                }
              },
            )
          : null,
      automaticallyImplyLeading: canPop,
    );
  }
}
