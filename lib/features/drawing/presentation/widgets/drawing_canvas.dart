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
    return RepaintBoundary(
      key: _repaintKey,
      child: ValueListenableBuilder<Brush>(
        valueListenable: widget.controller.brushNotifier,
        builder: (context, brush, _) {
          return AnimatedBuilder(
            animation: widget.controller.repaint,
            builder: (context, _) {
              return SizedBox.expand(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: widget.backgroundColor),
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
                    // Custom drawing surface: capture gestures and paint strokes
                    GestureDetector(
                      onPanStart: (details) {
                        widget.controller.startStroke(details.localPosition);
                      },
                      onPanUpdate: (details) {
                        widget.controller.addPoint(details.localPosition);
                      },
                      onPanEnd: (details) {
                        widget.controller.endStroke();
                      },
                      child: CustomPaint(
                        painter: SketchPainter(
                          strokes: widget.controller.strokes.value,
                          currentStroke: widget.controller.current.value,
                          repaint: widget.controller.repaint,
                        ),
                        size: Size.infinite,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
