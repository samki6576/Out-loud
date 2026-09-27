import 'package:flutter/material.dart';
import '../theme.dart';

/// Serene miniature landscape mountain + sun logo emblem — matches user reference image.
class OutLoudLogo extends StatelessWidget {
  final double size;
  final bool animate;
  const OutLoudLogo({
    super.key,
    this.size = 38,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(size * 0.32);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.lavender.withValues(alpha: 0.28),
            blurRadius: size * 0.25,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: CustomPaint(
          painter: _MiniLandscapePainter(),
        ),
      ),
    );
  }
}

class _MiniLandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background sky gradient
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFE8E0FF), Color(0xFFD4EAD9)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), skyPaint);

    // Sun with soft warmth
    final sunCenter = Offset(w * 0.72, h * 0.32);
    canvas.drawCircle(
      sunCenter,
      w * 0.22,
      Paint()..color = const Color(0xFFFFD98E),
    );

    // Back lavender mountain
    final backMountain = Path()
      ..moveTo(0, h * 0.75)
      ..lineTo(w * 0.35, h * 0.38)
      ..lineTo(w * 0.65, h * 0.75)
      ..close();
    canvas.drawPath(backMountain, Paint()..color = const Color(0xFFC8B8FF));

    // Front sage mountain
    final frontMountain = Path()
      ..moveTo(w * 0.25, h)
      ..lineTo(w * 0.6, h * 0.45)
      ..lineTo(w * 0.95, h)
      ..close();
    canvas.drawPath(frontMountain, Paint()..color = AppColors.sage);

    // Foreground grass strip
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.82, w, h * 0.18),
      Paint()..color = const Color(0xFFA8D8B9),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
