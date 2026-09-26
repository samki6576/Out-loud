import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';

/// Ultra-optimized, seasonal animated illustration with trees rooted on ground, flowers, birds, petals, leaves & snow.
class CalmIllustration extends StatefulWidget {
  final double height;
  final Season? season;
  const CalmIllustration({
    super.key,
    this.height = 180,
    this.season,
  });

  @override
  State<CalmIllustration> createState() => _CalmIllustrationState();
}

class _CalmIllustrationState extends State<CalmIllustration>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      if (_controller.isAnimating) _controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      if (!_controller.isAnimating) _controller.repeat();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSeason = widget.season ?? SeasonHelper.getCurrentSeason();

    return RepaintBoundary(
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _AnimatedCalmPainter(
                progress: _controller.value,
                season: currentSeason,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedCalmPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Season season;

  // Cached paint objects to eliminate memory allocations on 60/120Hz render cycles
  static final Paint _cloudPaint = Paint()..color = Colors.white.withValues(alpha: 0.72);
  static final Paint _sunCenterPaint = Paint()..color = const Color(0xFFFFD98E);
  static final Paint _backMountainPaint = Paint()..color = const Color(0xFFC8B8FF);
  static final Paint _frontMountainPaint = Paint()..color = AppColors.sage;
  static final Paint _sage2MountainPaint = Paint()..color = const Color(0xFF6FB48E);
  static final Paint _grassPaint = Paint()..color = const Color(0xFFA8D8B9);
  static final Paint _trunkPaint = Paint()..color = const Color(0xFF5D4037);
  static final Paint _petalPaint = Paint()..color = const Color(0xFFFFB7D5).withValues(alpha: 0.85);
  static final Paint _leafPaint = Paint()..color = const Color(0xFFE07A5F).withValues(alpha: 0.85);
  static final Paint _snowPaint = Paint()..color = Colors.white.withValues(alpha: 0.9);
  static final Paint _motePaint = Paint()..color = const Color(0xFFFFF2B2).withValues(alpha: 0.7);
  static final Paint _birdPaint = Paint()
    ..color = const Color(0xFF4A4A68).withValues(alpha: 0.85)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..strokeCap = StrokeCap.round;

  _AnimatedCalmPainter({required this.progress, required this.season});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Seasonal Sky Gradient
    final skyPaint = Paint()
      ..shader = _getSkyGradient(season).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, w, h),
        const Radius.circular(28),
      ),
      skyPaint,
    );

    // 2. Animated Sun Glow
    final pulse = sin(progress * 2 * pi);
    final sunCenter = Offset(w * 0.78, h * 0.28);
    final glowRadius = 55 + (pulse * 5);

    final sunGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          _getSunGlowColor(season).withValues(alpha: 0.65),
          _getSunGlowColor(season).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: glowRadius));

    canvas.drawCircle(sunCenter, glowRadius, sunGlow);
    canvas.drawCircle(sunCenter, 22, _sunCenterPaint);

    // 3. Mountain Ranges (Background landscape)
    final backMountain = Path()
      ..moveTo(0, h * 0.75)
      ..lineTo(w * 0.3, h * 0.35)
      ..lineTo(w * 0.55, h * 0.75)
      ..close();
    canvas.drawPath(backMountain, _backMountainPaint);

    final frontMountain = Path()
      ..moveTo(w * 0.25, h)
      ..lineTo(w * 0.55, h * 0.42)
      ..lineTo(w * 0.85, h)
      ..close();
    canvas.drawPath(frontMountain, _frontMountainPaint);

    final sage2 = Path()
      ..moveTo(w * 0.55, h)
      ..lineTo(w * 0.78, h * 0.55)
      ..lineTo(w * 1.0, h)
      ..close();
    canvas.drawPath(sage2, _sage2MountainPaint);

    // 4. Drifting Clouds
    final cloudOffset1 = (progress * 30) % w;
    final cloudOffset2 = (progress * 20) % w;

    _drawCloud(canvas, Offset((w * 0.1 + cloudOffset1) % (w + 60) - 30, h * 0.22), 28);
    _drawCloud(canvas, Offset((w * 0.5 + cloudOffset2) % (w + 60) - 30, h * 0.16), 22);
    _drawCloud(canvas, Offset((w * 0.75 - cloudOffset1) % (w + 60) - 30, h * 0.3), 24);

    // 5. Flying Birds
    double b1X = ((progress * 1.2 * w) % (w + 80)) - 40;
    double b1Y = h * 0.25 + sin(progress * 4 * pi) * 5;
    double flap1 = sin(progress * 16 * pi);
    _drawBird(canvas, Offset(b1X, b1Y), flap1, 1.0);

    double b2X = (((progress * 1.2 - 0.15) * w) % (w + 80)) - 40;
    double b2Y = h * 0.32 + cos(progress * 4 * pi) * 4;
    double flap2 = sin((progress + 0.2) * 16 * pi);
    _drawBird(canvas, Offset(b2X, b2Y), flap2, 0.75);

    double b3X = (((progress * 1.0 + 0.3) * w) % (w + 80)) - 40;
    double b3Y = h * 0.18 + sin((progress + 0.5) * 3 * pi) * 3;
    double flap3 = sin((progress + 0.4) * 14 * pi);
    _drawBird(canvas, Offset(b3X, b3Y), flap3, 0.6);

    // 6. Seasonal Particles (Petals, Leaves, Snow, Motes)
    _drawSeasonalParticles(canvas, w, h);

    // 7. Bottom Grass / Foreground Ground Strip
    final groundY = h * 0.88;
    final grass = Path()
      ..moveTo(0, groundY)
      ..quadraticBezierTo(w * 0.25, groundY - 6, w * 0.5, groundY)
      ..quadraticBezierTo(w * 0.75, groundY + 6, w, groundY - 2)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(grass, _getGrassPaint(season));

    // 8. Ground-Rooted Trees (Planted strictly on the ground line)
    _drawGroundTrees(canvas, w, groundY);

    // 9. Foreground Blooming Flowers & Swaying Grass
    _drawForegroundFlowers(canvas, w, h);
  }

  void _drawGroundTrees(Canvas canvas, double w, double groundY) {
    // Tree 1: Left Ground
    _drawTree(canvas, Offset(w * 0.12, groundY), scale: 0.9, foliageColor: _getFoliageColor(season, 1));
    // Tree 2: Middle-Left Ground
    _drawTree(canvas, Offset(w * 0.32, groundY + 2), scale: 1.15, foliageColor: _getFoliageColor(season, 2));
    // Tree 3: Middle-Right Ground
    _drawTree(canvas, Offset(w * 0.68, groundY + 1), scale: 1.05, foliageColor: _getFoliageColor(season, 3));
    // Tree 4: Right Ground
    _drawTree(canvas, Offset(w * 0.88, groundY - 1), scale: 0.85, foliageColor: _getFoliageColor(season, 1));
  }

  void _drawTree(Canvas canvas, Offset base, {required double scale, required Color foliageColor}) {
    // Trunk rooted on ground
    final trunkWidth = 4.5 * scale;
    final trunkHeight = 18.0 * scale;
    canvas.drawRect(
      Rect.fromLTWH(base.dx - trunkWidth / 2, base.dy - trunkHeight, trunkWidth, trunkHeight),
      _trunkPaint,
    );

    // Foliage (Triangular Pine / Round Canopy)
    final foliagePaint = Paint()..color = foliageColor;
    final top = base.dy - trunkHeight;

    if (season == Season.spring) {
      // Round Sakura / Cherry Blossom Canopy
      canvas.drawCircle(Offset(base.dx, top - 12 * scale), 16 * scale, foliagePaint);
      canvas.drawCircle(Offset(base.dx - 8 * scale, top - 8 * scale), 11 * scale, foliagePaint);
      canvas.drawCircle(Offset(base.dx + 8 * scale, top - 8 * scale), 11 * scale, foliagePaint);
    } else {
      // Pine Tree Layers
      final p1 = Path()
        ..moveTo(base.dx, top - 24 * scale)
        ..lineTo(base.dx - 12 * scale, top - 8 * scale)
        ..lineTo(base.dx + 12 * scale, top - 8 * scale)
        ..close();
      canvas.drawPath(p1, foliagePaint);

      final p2 = Path()
        ..moveTo(base.dx, top - 16 * scale)
        ..lineTo(base.dx - 16 * scale, top)
        ..lineTo(base.dx + 16 * scale, top)
        ..close();
      canvas.drawPath(p2, foliagePaint);

      // Winter Snow Cap
      if (season == Season.winter) {
        final snowCap = Path()
          ..moveTo(base.dx, top - 24 * scale)
          ..lineTo(base.dx - 6 * scale, top - 16 * scale)
          ..lineTo(base.dx + 6 * scale, top - 16 * scale)
          ..close();
        canvas.drawPath(snowCap, _snowPaint);
      }
    }
  }

  void _drawForegroundFlowers(Canvas canvas, double w, double h) {
    if (season == Season.winter) return; // Snow covers flowers in winter

    final sway = sin(progress * 2 * pi) * 2.0;

    // Flowers blooming along the bottom grass ground
    final flowerPositions = [
      Offset(w * 0.05, h * 0.93),
      Offset(w * 0.22, h * 0.94),
      Offset(w * 0.45, h * 0.92),
      Offset(w * 0.58, h * 0.93),
      Offset(w * 0.78, h * 0.92),
      Offset(w * 0.94, h * 0.94),
    ];

    final colors = season == Season.spring
        ? [const Color(0xFFFFB7D5), const Color(0xFFC8B8FF), const Color(0xFFFFE5A8)]
        : season == Season.summer
            ? [const Color(0xFFFF8B8B), const Color(0xFFFFD98E), const Color(0xFFB5D8F0)]
            : [const Color(0xFFE07A5F), const Color(0xFFF4A261), const Color(0xFFE0A96D)];

    final stemPaint = Paint()
      ..color = const Color(0xFF4A7C59)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < flowerPositions.length; i++) {
      final pos = flowerPositions[i];
      final flowerColor = Paint()..color = colors[i % colors.length];

      // Stem
      canvas.drawLine(pos, Offset(pos.dx + sway, pos.dy - 12), stemPaint);

      // Petals
      final top = Offset(pos.dx + sway, pos.dy - 12);
      canvas.drawCircle(top, 3.5, flowerColor);
      canvas.drawCircle(top + const Offset(-3, 0), 2.5, flowerColor);
      canvas.drawCircle(top + const Offset(3, 0), 2.5, flowerColor);
      canvas.drawCircle(top + const Offset(0, -3), 2.5, flowerColor);
      canvas.drawCircle(top + const Offset(0, 3), 2.5, flowerColor);

      // Center
      canvas.drawCircle(top, 1.5, _sunCenterPaint);
    }
  }

  Color _getFoliageColor(Season s, int index) {
    switch (s) {
      case Season.spring:
        return index == 1 ? const Color(0xFFFFB7D5) : const Color(0xFFA8D8B9);
      case Season.summer:
        return index == 2 ? const Color(0xFF4A7C59) : const Color(0xFF6FB48E);
      case Season.autumn:
        return index == 1 ? const Color(0xFFE07A5F) : const Color(0xFFF4A261);
      case Season.winter:
        return const Color(0xFF5A7B74);
    }
  }

  void _drawSeasonalParticles(Canvas canvas, double w, double h) {
    switch (season) {
      case Season.spring:
        for (int i = 0; i < 7; i++) {
          double px = (w - (progress * 50 + i * 55) % w);
          double py = ((progress * 40 + i * 25) % (h * 0.85));
          double wobble = sin(progress * 4 * pi + i) * 8;
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset(px + wobble, py),
              width: 7,
              height: 4,
            ),
            _petalPaint,
          );
        }
        break;

      case Season.summer:
        for (int i = 0; i < 6; i++) {
          double sx = (w * 0.18 * i + progress * 35) % w;
          double sy = (h * 0.75 - (progress * 30 + i * 20) % (h * 0.6));
          double rad = 1.8 + (sin(progress * 2 * pi + i) * 0.8);
          canvas.drawCircle(Offset(sx, sy), rad, _motePaint);
        }
        break;

      case Season.autumn:
        for (int i = 0; i < 6; i++) {
          double lx = ((progress * 45 + i * 60) % w);
          double ly = ((progress * 50 + i * 30) % (h * 0.8));
          double wobble = cos(progress * 3 * pi + i) * 10;
          canvas.save();
          canvas.translate(lx + wobble, ly);
          canvas.rotate(progress * 2 * pi + i);
          final leafPath = Path()
            ..moveTo(0, -5)
            ..quadraticBezierTo(4, -2, 0, 5)
            ..quadraticBezierTo(-4, -2, 0, -5);
          canvas.drawPath(leafPath, _leafPaint);
          canvas.restore();
        }
        break;

      case Season.winter:
        for (int i = 0; i < 8; i++) {
          double sx = ((i * 45 + progress * 20) % w);
          double sy = ((progress * 60 + i * 22) % (h * 0.85));
          double wobble = sin(progress * 2 * pi + i) * 5;
          double size = 1.5 + (i % 3) * 0.8;
          canvas.drawCircle(Offset(sx + wobble, sy), size, _snowPaint);
        }
        break;
    }
  }

  LinearGradient _getSkyGradient(Season s) {
    switch (s) {
      case Season.spring:
        return const LinearGradient(
          colors: [Color(0xFFFFF0F5), Color(0xFFE8E0FF), Color(0xFFD4EAD9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case Season.summer:
        return const LinearGradient(
          colors: [Color(0xFFFFE5D6), Color(0xFFFFF1E8), Color(0xFFE8F4F8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case Season.autumn:
        return const LinearGradient(
          colors: [Color(0xFFFDF0ED), Color(0xFFFCE5CD), Color(0xFFF7E2D6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case Season.winter:
        return const LinearGradient(
          colors: [Color(0xFFF0F4F8), Color(0xFFE2ECE9), Color(0xFFD8E2DC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  Color _getSunGlowColor(Season s) {
    switch (s) {
      case Season.spring:
        return const Color(0xFFFFD6E8);
      case Season.summer:
        return const Color(0xFFFFE5A8);
      case Season.autumn:
        return const Color(0xFFF4A261);
      case Season.winter:
        return const Color(0xFFBEE3F8);
    }
  }

  Paint _getGrassPaint(Season s) {
    switch (s) {
      case Season.spring:
        return _grassPaint;
      case Season.summer:
        return Paint()..color = const Color(0xFF8BC9A8);
      case Season.autumn:
        return Paint()..color = const Color(0xFFE0A96D);
      case Season.winter:
        return Paint()..color = const Color(0xFFC5D3CD);
    }
  }

  void _drawCloud(Canvas canvas, Offset center, double size) {
    canvas.drawCircle(center, size, _cloudPaint);
    canvas.drawCircle(center + Offset(size * 0.6, size * 0.2), size * 0.7, _cloudPaint);
    canvas.drawCircle(center - Offset(size * 0.6, size * 0.1), size * 0.6, _cloudPaint);
  }

  void _drawBird(Canvas canvas, Offset pos, double flap, double scale) {
    final path = Path();
    double span = 11 * scale;
    double wingUp = 5 * scale * flap;

    path.moveTo(pos.dx - span, pos.dy - wingUp);
    path.quadraticBezierTo(
      pos.dx - span * 0.5,
      pos.dy - span * 0.4,
      pos.dx,
      pos.dy,
    );
    path.quadraticBezierTo(
      pos.dx + span * 0.5,
      pos.dy - span * 0.4,
      pos.dx + span,
      pos.dy - wingUp,
    );

    canvas.drawPath(path, _birdPaint);
  }

  @override
  bool shouldRepaint(covariant _AnimatedCalmPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.season != season;
  }
}
