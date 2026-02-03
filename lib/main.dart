import 'package:flutter/material.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/presentation/widgets/full_screen_loader.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _showLoader = true;

  @override
  void initState() {
    super.initState();
    // Mostrar loader al inicio y ocultarlo tras 6 segundos.
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() => _showLoader = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      routerConfig: appRouter,
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox(),
            if (_showLoader) const FullScreenLoader(),
          ],
        );
      },
    );
  }
}
