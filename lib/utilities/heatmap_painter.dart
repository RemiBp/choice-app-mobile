import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class HeatmapPainter extends CustomPainter {
  final List<Offset> points;
  final List<Map<String, dynamic>> rawData;
  final double zoom;

  HeatmapPainter({
    required this.points,
    required this.rawData,
    required this.zoom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..blendMode = BlendMode.srcOver;

    for (int i = 0; i < points.length; i++) {
      final offset = points[i];
      final intensity = (rawData[i]["count"] ?? 1).toDouble();

      // FIXED RADIUS
      double radius = (12 + zoom * 1.8).clamp(12, 40);
      radius += (intensity * 1.2).clamp(0, 10);

      final gradient = ui.Gradient.radial(
        offset,
        radius,
        [
          Colors.blue.withOpacity(0.00),
          Colors.green.withOpacity(0.20),
          Colors.yellow.withOpacity(0.35),
          Colors.red.withOpacity(0.55),
        ],
        [0.0, 0.4, 0.7, 1.0],
      );

      paint.shader = gradient;
      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant HeatmapPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.zoom != zoom;
  }
}
