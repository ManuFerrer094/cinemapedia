import 'dart:math';

import 'package:flutter/material.dart';

class FullScreenLoader extends StatefulWidget {
  const FullScreenLoader({Key? key}) : super(key: key);

  @override
  State<FullScreenLoader> createState() => _FullScreenLoaderState();
}

class _FullScreenLoaderState extends State<FullScreenLoader>
    with TickerProviderStateMixin {
  late final AnimationController _filmController;
  late final AnimationController _spinController;
  late final AnimationController _popController;
  late final AnimationController _textController;

  final List<String> _messages = const [
    'Preparando palomitas...',
    'Cargando escenas...',
    'Ajustando foco...',
    'Calentando proyector...',
    'Subiendo volumen al drama...'
  ];

  @override
  void initState() {
    super.initState();

    _filmController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();

    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _textController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _messages.length * 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _filmController.dispose();
    _spinController.dispose();
    _popController.dispose();
    _textController.dispose();
    super.dispose();
  }

  String _currentMessage() {
    final t = _textController.value * _messages.length;
    final idx = t.floor() % _messages.length;
    return _messages[idx];
  }

  double _messageOpacity() {
    final t = _textController.value * _messages.length;
    final local = t - t.floor(); // 0..1 within current message
    // triangular fade in/out
    return 1.0 - (local - 0.5).abs() * 2.0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: SizedBox.expand(
        child: Stack(
          children: [
            // Fondo dramático
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _filmController,
                builder: (_, __) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black,
                          Colors.grey.shade900,
                          Colors.indigo.shade900,
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Film strip moving horizontally
            Positioned(
              top: size.height * 0.06,
              left: 0,
              right: 0,
              height: 90,
              child: AnimatedBuilder(
                animation: _filmController,
                builder: (context, child) {
                  final dx = (_filmController.value * 1.0) * 200 - 100;
                  return Transform.translate(
                    offset: Offset(-dx, 0),
                    child: Opacity(
                      opacity: 0.18,
                      child: _FilmStrip(),
                    ),
                  );
                },
              ),
            ),

            // Centro: carrete giratorio y emoji de palomitas
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _spinController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _spinController.value * 2 * pi,
                        child: child,
                      );
                    },
                    child: _FilmReel(size: 140),
                  ),

                  const SizedBox(height: 18),

                  // Frase con fade
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _messageOpacity().clamp(0.0, 1.0),
                        child: child,
                      );
                    },
                    child: Text(
                      _currentMessage(),
                      style: TextStyle(
                        color: Colors.amber.shade100,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        shadows: const [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Palomitas emoji que rebota
                  AnimatedBuilder(
                    animation: _popController,
                    builder: (context, child) {
                      final bounce = Curves.easeInOut.transform(_popController.value);
                      return Transform.translate(
                        offset: Offset(0, -8 * bounce),
                        child: child,
                      );
                    },
                    child: Text(
                      '🍿',
                      style: TextStyle(fontSize: 48, shadows: [
                        Shadow(color: Colors.black26, blurRadius: 6)
                      ]),
                    ),
                  ),
                ],
              ),
            ),

            // Pie: credit-like subtle text
            Positioned(
              bottom: 28,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Cinemapedia · Cargando experiencia',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilmReel extends StatelessWidget {
  final double size;
  const _FilmReel({Key? key, this.size = 100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Colors.grey.shade300, Colors.grey.shade800],
          stops: const [0.2, 1.0],
        ),
        boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black26)],
      ),
      child: Center(
        child: Container(
          width: size * 0.58,
          height: size * 0.58,
          decoration: BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.circle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (i) {
              return Container(
                width: size * 0.06,
                height: size * 0.16,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _FilmStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final repeats = (width / 220).ceil() + 2;
      return Row(
        children: List.generate(repeats, (i) => _stripSegment()),
      );
    });
  }

  Widget _stripSegment() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      width: 200,
      height: 90,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (_) => _hole()),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (_) => _hole()),
          ),
        ],
      ),
    );
  }

  Widget _hole() {
    return Container(
      width: 10,
      height: 14,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
