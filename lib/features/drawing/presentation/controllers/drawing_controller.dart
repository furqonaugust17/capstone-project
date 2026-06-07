import 'package:flutter/material.dart';
import '../../domain/entities/point.dart';
import '../../domain/entities/stroke.dart';
import '../../domain/entities/brush.dart';

/// Controller that manages incremental drawing state to minimize rebuilds.
///
/// The controller exposes ValueNotifiers that are consumed by the
/// CustomPainter and UI widgets directly. Higher-level actions (save/load)
/// should be orchestrated via the Bloc / UseCases so persistence follows
/// clean architecture.
class DrawingController extends ChangeNotifier {
  final ValueNotifier<List<Stroke>> strokes = ValueNotifier<List<Stroke>>([]);
  final ValueNotifier<Stroke?> current = ValueNotifier<Stroke?>(null);
  Brush brush;
  final ValueNotifier<Brush> brushNotifier;
  final ChangeNotifier _repaint = ChangeNotifier();

  DrawingController({Brush? initialBrush})
    : brush =
          initialBrush ??
          const Brush(color: Color(0xFF000000), strokeWidth: 6.0),
      brushNotifier = ValueNotifier<Brush>(
        initialBrush ?? const Brush(color: Color(0xFF000000), strokeWidth: 6.0),
      ) {
    // wire strokes/current to repaint notifier
    strokes.addListener(() => _repaint.notifyListeners());
    current.addListener(() => _repaint.notifyListeners());
  }

  void startStroke(Offset pos) {
    final p = Point(pos.dx, pos.dy);
    final stroke = Stroke(
      points: [p],
      colorValue: brush.color.toARGB32(),
      strokeWidth: brush.strokeWidth,
      isEraser: brush.tool == ToolType.eraser,
    );
    current.value = stroke;
  }

  void addPoint(Offset pos) {
    final c = current.value;
    if (c == null) return;
    c.points.add(Point(pos.dx, pos.dy));
    // Notify painter only for current stroke change
    current.notifyListeners();
  }

  void endStroke() {
    final c = current.value;
    if (c == null) return;
    final list = List<Stroke>.from(strokes.value)..add(c);
    strokes.value = list;
    current.value = null;
    // notify both notifiers; they already triggered
  }

  void undo() {
    final list = List<Stroke>.from(strokes.value);
    if (list.isNotEmpty) {
      list.removeLast();
      strokes.value = list;
    }
  }

  void clear() {
    strokes.value = [];
    current.value = null;
  }

  void setBrush(Brush b) {
    brush = b;
    brushNotifier.value = b;
  }

  void disposeController() {
    strokes.dispose();
    current.dispose();
    brushNotifier.dispose();
    _repaint.dispose();
    dispose();
  }

  Listenable get repaint => _repaint;
}
