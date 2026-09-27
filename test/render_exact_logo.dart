import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 512, 512));

  // RRect card container matching OutLoudLogo
  final RRect cardRect = RRect.fromRectAndRadius(
    const Rect.fromLTWH(16, 16, 480, 480),
    const Radius.circular(150),
  );

  // Save state & clip canvas
  canvas.save();
  canvas.clipRRect(cardRect);

  // Background sky gradient
  final skyPaint = Paint()
    ..shader = const LinearGradient(
      colors: [Color(0xFFE8E0FF), Color(0xFFD4EAD9)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(const Rect.fromLTWH(0, 0, 512, 512));
  canvas.drawRect(const Rect.fromLTWH(0, 0, 512, 512), skyPaint);

  // Sun
  final sunCenter = const Offset(512 * 0.72, 512 * 0.32);
  canvas.drawCircle(
    sunCenter,
    512 * 0.22,
    Paint()..color = const Color(0xFFFFD98E),
  );

  // Back lavender mountain
  final backMountain = Path()
    ..moveTo(0, 512 * 0.75)
    ..lineTo(512 * 0.35, 512 * 0.38)
    ..lineTo(512 * 0.65, 512 * 0.75)
    ..close();
  canvas.drawPath(backMountain, Paint()..color = const Color(0xFFC8B8FF));

  // Front sage mountain
  final frontMountain = Path()
    ..moveTo(512 * 0.25, 512)
    ..lineTo(512 * 0.6, 512 * 0.45)
    ..lineTo(512 * 0.95, 512)
    ..close();
  canvas.drawPath(frontMountain, Paint()..color = const Color(0xFF8BC9A8));

  // Foreground grass strip
  canvas.drawRect(
    const Rect.fromLTWH(0, 512 * 0.82, 512, 512 * 0.18),
    Paint()..color = const Color(0xFFA8D8B9),
  );

  canvas.restore();

  final picture = recorder.endRecording();
  final img = await picture.toImage(512, 512);
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

  if (byteData != null) {
    final buffer = byteData.buffer.asUint8List();
    File('assets/logo.png').writeAsBytesSync(buffer);
    print('SUCCESS: assets/logo.png rendered pixel-perfect from Flutter dart:ui!');
  }
}
