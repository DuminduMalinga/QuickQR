import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 2900),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            setState(() => _isComplete = true);
          }
        });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isComplete) return const HomePage();

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final value = _controller.value;
          return DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kIndigo, Color(0xFF3730A3), kNavy],
                stops: [0, 0.48, 1],
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(painter: _BackgroundPainter(progress: value)),
                Center(
                  child: Transform.translate(
                    offset: const Offset(0, -22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLogo(value),
                        const SizedBox(height: 32),
                        AnimatedOpacity(
                          opacity: _textOpacity(value),
                          duration: const Duration(milliseconds: 180),
                          child: const Text(
                            'QuickQR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        AnimatedOpacity(
                          opacity: _taglineOpacity(value),
                          duration: const Duration(milliseconds: 220),
                          child: const Text(
                            'Create. Save. Share.',
                            style: TextStyle(
                              color: Color(0xFFDCE7FF),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 56,
                  left: 0,
                  right: 0,
                  child: _LoadingDots(progress: value),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double _textOpacity(double value) => ((value - 0.79) / 0.12).clamp(0.0, 1.0);

  double _taglineOpacity(double value) =>
      ((value - 0.86) / 0.1).clamp(0.0, 1.0);

  Widget _buildLogo(double value) {
    final scaleProgress = Curves.elasticOut.transform(
      ((value - 0.6) / 0.2).clamp(0.0, 1.0),
    );
    final scale = 0.72 + (scaleProgress * 0.28);
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 194,
        height: 194,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: kBlue.withValues(alpha: 0.08 + (0.18 * _pulse(value))),
              blurRadius: 40 + (18 * _pulse(value)),
              spreadRadius: 4,
            ),
          ],
        ),
        child: CustomPaint(painter: _AnimatedQrPainter(progress: value)),
      ),
    );
  }

  double _pulse(double value) {
    if (value < 0.62) return 0;
    return (math.sin((value - 0.62) * math.pi * 9).abs() *
            ((value - 0.62) / 0.38).clamp(0.0, 1.0))
        .clamp(0.0, 1.0);
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final wave = math.sin((progress * math.pi * 8) - index * 1.2);
        final opacity = 0.4 + (0.6 * ((wave + 1) / 2));
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: kBlue,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  _BackgroundPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              kBlue.withValues(alpha: 0.18),
              kIndigo.withValues(alpha: 0.06),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width / 2, size.height * 0.42),
              radius: size.width * 0.72,
            ),
          );
    canvas.drawRect(Offset.zero & size, glow);

    final particlePaint = Paint()..color = Colors.white.withValues(alpha: 0.06);
    const particles = [
      Offset(0.12, 0.18),
      Offset(0.83, 0.24),
      Offset(0.17, 0.71),
      Offset(0.9, 0.66),
      Offset(0.08, 0.46),
      Offset(0.77, 0.82),
    ];
    for (var i = 0; i < particles.length; i++) {
      final drift = math.sin(progress * math.pi * 2 + i) * 5;
      final center = Offset(
        size.width * particles[i].dx,
        size.height * particles[i].dy + drift,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center,
            width: 5 + (i % 2) * 3,
            height: 5 + (i % 2) * 3,
          ),
          const Radius.circular(2),
        ),
        particlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _AnimatedQrPainter extends CustomPainter {
  _AnimatedQrPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final frameProgress = ((progress - 0.17) / 0.24).clamp(0.0, 1.0);
    final pixelsProgress = ((progress - 0.4) / 0.23).clamp(0.0, 1.0);
    final pulse = progress < 0.62
        ? 0.0
        : (math.sin((progress - 0.62) * math.pi * 9).abs() *
                  ((progress - 0.62) / 0.38).clamp(0.0, 1.0))
              .clamp(0.0, 1.0);
    final moduleSize = size.shortestSide / 13;
    final offset = Offset(
      (size.width - moduleSize * 13) / 2,
      (size.height - moduleSize * 13) / 2,
    );
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.93 + (pulse * 0.07));

    void module(int row, int column, {double opacity = 1}) {
      if (row < 0 || column < 0 || row >= 13 || column >= 13) return;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            offset.dx + column * moduleSize,
            offset.dy + row * moduleSize,
            moduleSize - 1.8,
            moduleSize - 1.8,
          ),
          const Radius.circular(1.5),
        ),
        paint..color = Colors.white.withValues(alpha: opacity),
      );
    }

    void finder(int top, int left) {
      final reveal = Curves.easeOutCubic.transform(frameProgress);
      for (var row = 0; row < 5; row++) {
        for (var column = 0; column < 5; column++) {
          final distance = math.max((row - 2).abs(), (column - 2).abs());
          final opacity = (reveal * (1.2 - distance * 0.12)).clamp(0.0, 1.0);
          final isOuter = row == 0 || row == 4 || column == 0 || column == 4;
          final isCenter = row == 2 && column == 2;
          if (isOuter || isCenter) {
            module(top + row, left + column, opacity: opacity);
          }
        }
      }
    }

    finder(0, 0);
    finder(0, 8);
    finder(8, 0);

    final pixels = <Offset>[
      const Offset(6, 6),
      const Offset(7, 6),
      const Offset(6, 7),
      const Offset(8, 6),
      const Offset(6, 8),
      const Offset(7, 8),
      const Offset(8, 8),
      const Offset(5, 6),
      const Offset(6, 5),
      const Offset(9, 7),
      const Offset(10, 7),
      const Offset(8, 10),
      const Offset(10, 10),
      const Offset(7, 10),
      const Offset(5, 10),
      const Offset(10, 5),
      const Offset(4, 6),
      const Offset(6, 10),
    ];
    final count = (pixels.length * Curves.easeOut.transform(pixelsProgress))
        .round();
    for (var i = 0; i < count; i++) {
      module(pixels[i].dy.toInt(), pixels[i].dx.toInt());
    }

    if (progress >= 0.4 && progress <= 0.77) {
      final scanY = offset.dy + moduleSize * 13 * ((progress - 0.4) / 0.37);
      final scanPaint = Paint()
        ..color = kBlue.withValues(alpha: 0.9)
        ..strokeWidth = 2.2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawLine(
        Offset(offset.dx, scanY),
        Offset(offset.dx + moduleSize * 13, scanY),
        scanPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AnimatedQrPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
