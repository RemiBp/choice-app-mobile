import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utilities/heatmap_painter.dart';

class HeatmapOverlay extends StatefulWidget {
  final GoogleMapController controller;
  final double zoom;
  final List<Map<String, dynamic>> points;
  final GlobalKey mapKey;
  final Function(Map<String, dynamic> data, Offset position)? onPointTapped;

  const HeatmapOverlay({
    super.key,
    required this.controller,
    required this.zoom,
    required this.points,
    required this.mapKey,
    this.onPointTapped,
  });

  @override
  State<HeatmapOverlay> createState() => _HeatmapOverlayState();
}

class _HeatmapOverlayState extends State<HeatmapOverlay> {
  List<Offset> screenPoints = [];
  HeatmapPainter? _painter;
  bool _isComputing = false;
  int _computeVersion = 0;

  @override
  void initState() {
    super.initState();
    _computeScreenPoints();
  }

  @override
  void didUpdateWidget(HeatmapOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.zoom != widget.zoom ||
        oldWidget.points != widget.points) {
      _computeScreenPoints();
    }
  }

  Future<void> _computeScreenPoints() async {
    if (_isComputing) return;

    _isComputing = true;
    final currentVersion = ++_computeVersion;

    try {
      final RenderBox? mapBox = widget.mapKey.currentContext?.findRenderObject() as RenderBox?;
      final Offset mapOffset = mapBox?.localToGlobal(Offset.zero) ?? Offset.zero;

      final newPoints = <Offset>[];

      for (var p in widget.points) {
        try {
          final screenCoord = await widget.controller
              .getScreenCoordinate(LatLng(p["lat"], p["lng"]));

          if (currentVersion != _computeVersion) {
            return;
          }

          // Add map's offset to screen coordinates
          final offset = Offset(
            screenCoord.x.toDouble() + mapOffset.dx,
            screenCoord.y.toDouble() + mapOffset.dy,
          );
          newPoints.add(offset);

          // DEBUG: Print first point to verify coordinates
          if (newPoints.length == 1) {
            debugPrint("🎯 First heatmap point - Lat: ${p["lat"]}, Lng: ${p["lng"]} -> Screen: $offset (Map offset: $mapOffset)");
          }
        } catch (e) {
          debugPrint("❌ Error converting coordinates: $e");
        }
      }

      if (mounted && currentVersion == _computeVersion) {
        setState(() {
          screenPoints = newPoints;
        });
        debugPrint("✅ Heatmap updated with ${newPoints.length} points at zoom ${widget.zoom}");
      }
    } finally {
      if (currentVersion == _computeVersion) {
        _isComputing = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (screenPoints.isEmpty || screenPoints.length != widget.points.length) {
      return const SizedBox.shrink();
    }

    _painter = HeatmapPainter(
      points: screenPoints,
      rawData: widget.points,
      zoom: widget.zoom,
    );

    return _CustomHitTestWidget(
      painter: _painter!,
      onTap: (position, index) {
        if (widget.onPointTapped != null && index < widget.points.length) {
          widget.onPointTapped!(widget.points[index], screenPoints[index]);
        }
      },
      child: CustomPaint(
        painter: _painter,
        size: Size.infinite,
        child: Container(),
      ),
    );
  }
}

class _CustomHitTestWidget extends SingleChildRenderObjectWidget {
  final HeatmapPainter painter;
  final Function(Offset position, int index) onTap;

  const _CustomHitTestWidget({
    required this.painter,
    required this.onTap,
    required Widget child,
  }) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCustomHitTest(painter: painter, onTap: onTap);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderCustomHitTest renderObject) {
    renderObject
      ..painter = painter
      ..onTap = onTap;
  }
}

class _RenderCustomHitTest extends RenderProxyBox {
  HeatmapPainter painter;
  Function(Offset position, int index) onTap;

  _RenderCustomHitTest({
    required this.painter,
    required this.onTap,
  });

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final index = painter.findTappedPoint(position);
    if (index != null) {
      if (result.addWithPaintOffset(
        offset: Offset.zero,
        position: position,
        hitTest: (result, transformed) {
          result.add(BoxHitTestEntry(this, transformed));
          return true;
        },
      )) {
        onTap(position, index);
        return true;
      }
    }
    return false;
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      final index = painter.findTappedPoint(event.localPosition);
      if (index != null) {
        onTap(event.localPosition, index);
      }
    }
  }
}

class HeatmapTooltip extends StatelessWidget {
  final Offset position;
  final int userCount;
  final VoidCallback onDismiss;

  const HeatmapTooltip({
    super.key,
    required this.position,
    required this.userCount,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$userCount user${userCount == 1 ? '' : 's'} in this area',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDismiss,
            child: Icon(Icons.close, size: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}