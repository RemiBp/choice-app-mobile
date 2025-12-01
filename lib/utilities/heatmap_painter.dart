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

    final paint = Paint()..blendMode = BlendMode.srcOver;

    final maxIntensity = rawData
        .map((e) => (e["count"] ?? 1).toDouble())
        .reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < points.length; i++) {
      final offset = points[i];
      final intensity = (rawData[i]["count"] ?? 1).toDouble();
      final normalizedIntensity = (intensity / maxIntensity).clamp(0.0, 1.0);

      // Adjust radius based on zoom
      double radius = (15 + zoom * 2.0).clamp(15, 45);
      radius += (intensity * 1.5).clamp(0, 12);

      final gradient = RadialGradient(
        colors: [
          Colors.red.withValues(alpha:0.75 + normalizedIntensity * 0.2),
          const Color(0xFFFF5722).withValues(alpha:0.65 + normalizedIntensity * 0.15),
          const Color(0xFFFF9800).withValues(alpha:0.55 + normalizedIntensity * 0.1),
          const Color(0xFFFFEB3B).withValues(alpha:0.45 + normalizedIntensity * 0.05),
          const Color(0xFF8BC34A).withValues(alpha:0.35),
          const Color(0xFF4CAF50).withValues(alpha:0.25),
          const Color(0xFF03A9F4).withValues(alpha:0.18),
          const Color(0xFF2196F3).withValues(alpha:0.10),
          const Color(0xFF2196F3).withValues(alpha:0.0),
        ],
        stops: const [0.0, 0.15, 0.25, 0.40, 0.55, 0.68, 0.80, 0.92, 1.0],
      ).createShader(Rect.fromCircle(center: offset, radius: radius));

      paint.shader = gradient;
      canvas.drawCircle(offset, radius, paint);
    }
  }

  int? findTappedPoint(Offset position) {
    final maxIntensity = rawData
        .map((e) => (e["count"] ?? 1).toDouble())
        .reduce((a, b) => a > b ? a : b);

    for (int i = points.length - 1; i >= 0; i--) {
      final offset = points[i];
      final intensity = (rawData[i]["count"] ?? 1).toDouble();
      final normalizedIntensity = (intensity / maxIntensity).clamp(0.0, 1.0);

      double radius = (15 + zoom * 2.0).clamp(15, 45);
      radius += (intensity * 1.5).clamp(0, 12);

      final distance = (position - offset).distance;
      if (distance <= radius) {
        return i;
      }
    }
    return null;
  }

  @override
  bool shouldRepaint(covariant HeatmapPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.zoom != zoom ||
        oldDelegate.rawData != rawData;
  }
}