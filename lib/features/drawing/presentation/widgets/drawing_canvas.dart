import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../controllers/drawing_controller.dart';
import '../../domain/entities/brush.dart';
import '../painter/sketch_painter.dart';

class DrawingCanvas extends StatefulWidget {
  final DrawingController controller;
  final Color backgroundColor;
  final String? traceAssetPath;
  final double traceOpacity;

  const DrawingCanvas({
    super.key,
    required this.controller,
    this.backgroundColor = const Color(0xFFF7F9FC),
    this.traceAssetPath,
    this.traceOpacity = 0.35,
  });

  @override
  State<DrawingCanvas> createState() => DrawingCanvasState();
}

class DrawingCanvasState extends State<DrawingCanvas> {
  final GlobalKey _repaintKey = GlobalKey();

  Future<ui.Image?> captureImage({double pixelRatio = 2.0}) async {
    final ctx = _repaintKey.currentContext;
    if (ctx == null) return null;
    final boundary = ctx.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    return boundary.toImage(pixelRatio: pixelRatio);
  }

  void clear() {
    widget.controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Brush>(
      valueListenable: widget.controller.brushNotifier,
      builder: (context, brush, _) {
        return AnimatedBuilder(
          animation: widget.controller.repaint,
          builder: (context, _) {
            return SizedBox.expand(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 1) RepaintBoundary wraps ONLY the drawing surface
                  //    (background + strokes) so captureImage() never
                  //    includes the trace overlay.
                  RepaintBoundary(
                    key: _repaintKey,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanStart: (details) {
                        widget.controller.startStroke(details.localPosition);
                      },
                      onPanUpdate: (details) {
                        widget.controller.addPoint(details.localPosition);
                      },
                      onPanEnd: (details) {
                        widget.controller.endStroke();
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(color: widget.backgroundColor),
                          CustomPaint(
                            painter: SketchPainter(
                              strokes: widget.controller.strokes.value,
                              currentStroke: widget.controller.current.value,
                              repaint: widget.controller.repaint,
                            ),
                            size: Size.infinite,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2) Trace image layer — rendered ON TOP of the drawing
                  //    surface so the child can see the guide, but OUTSIDE
                  //    RepaintBoundary so it is excluded from capture.
                  //    IgnorePointer ensures it doesn't block drawing gestures.
                  if (widget.traceAssetPath != null)
                    IgnorePointer(
                      child: Center(
                        child: Opacity(
                          opacity: widget.traceOpacity,
                          child: FractionallySizedBox(
                            widthFactor: 1.2,
                            heightFactor: 1.2,
                            child: Image.asset(
                              widget.traceAssetPath!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
