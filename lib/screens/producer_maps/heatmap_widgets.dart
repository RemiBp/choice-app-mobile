import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utilities/heatmap_painter.dart';

class HeatmapOverlay extends StatefulWidget {
  final GoogleMapController controller;
  final double zoom;
  final List<Map<String, dynamic>> points;

  const HeatmapOverlay({
    super.key,
    required this.controller,
    required this.zoom,
    required this.points,
  });

  @override
  State<HeatmapOverlay> createState() => _HeatmapOverlayState();
}

class _HeatmapOverlayState extends State<HeatmapOverlay> {
  List<Offset> screenPoints = [];

  @override
  void didUpdateWidget(HeatmapOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _computeScreenPoints();
  }

  Future<void> _computeScreenPoints() async {
    final newPoints = <Offset>[];

    for (var p in widget.points) {
      final screenCoord = await widget.controller
          .getScreenCoordinate(LatLng(p["lat"], p["lng"]));

      newPoints.add(Offset(
        screenCoord.x.toDouble(),
        screenCoord.y.toDouble(),
      ));
    }

    if (mounted) {
      setState(() => screenPoints = newPoints);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (screenPoints.isEmpty) return const SizedBox.shrink();

    return IgnorePointer(
      child: CustomPaint(
        painter: HeatmapPainter(
          points: screenPoints,
          rawData: widget.points,
          zoom: widget.zoom,
        ),
        child: Container(),
      ),
    );
  }
}
