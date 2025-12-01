import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../appColors/colors.dart';
import '../../customWidgets/custom_text.dart';
import '../../res/res.dart';
import '../../utilities/heatmap_painter.dart';

class HeatmapOverlay extends StatefulWidget {
  final GoogleMapController controller;
  final double zoom;
  final List<Map<String, dynamic>> points;
  final Function(Map<String, dynamic> data, Offset position)? onPointTapped;

  const HeatmapOverlay({
    super.key,
    required this.controller,
    required this.zoom,
    required this.points,
    this.onPointTapped,
  });

  @override
  State<HeatmapOverlay> createState() => _HeatmapOverlayState();
}

class _HeatmapOverlayState extends State<HeatmapOverlay> {
  List<Offset> screenPoints = [];
  HeatmapPainter? _painter;
  bool _isComputing = false;

  @override
  void initState() {
    super.initState();
    _computeScreenPoints();
  }

  @override
  void didUpdateWidget(HeatmapOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // CRITICAL FIX: Recalculate on ANY change
    if (oldWidget.zoom != widget.zoom ||
        oldWidget.points != widget.points ||
        oldWidget.controller != widget.controller) {
      _computeScreenPoints();
    }
  }

  Future<void> _computeScreenPoints() async {
    // Prevent multiple simultaneous computations
    if (_isComputing) return;
    _isComputing = true;

    try {
      final newPoints = <Offset>[];

      // Batch process all points
      for (var p in widget.points) {
        try {
          final screenCoord = await widget.controller
              .getScreenCoordinate(LatLng(p["lat"], p["lng"]));
          newPoints.add(Offset(screenCoord.x.toDouble(), screenCoord.y.toDouble()));
        } catch (e) {
          debugPrint("Error converting coordinates: $e");
        }
      }

      if (mounted) {
        setState(() {
          screenPoints = newPoints;
        });
      }
    } finally {
      _isComputing = false;
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
        child: Container(),
      ),
    );
  }
}
// Custom widget that only accepts hits on heatmap bubbles
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
      padding: EdgeInsets.symmetric(
        horizontal: getWidth() * 0.04,
        vertical: getHeight() * 0.012,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: '$userCount user${userCount == 1 ? '' : 's'} in this area',
            fontSize: getWidth() * 0.032,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(width: getWidth() * 0.02),
          GestureDetector(
            onTap: onDismiss,
            child: Icon(Icons.close, size: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
