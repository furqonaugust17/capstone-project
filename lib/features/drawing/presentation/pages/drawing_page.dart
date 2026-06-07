import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/features/classification/presentation/bloc/classification_bloc.dart';

import '../widgets/drawing_canvas.dart';
import '../widgets/drawing_header.dart';
import '../../domain/entities/brush.dart';
import '../widgets/drawing_bottom_controls.dart';
import '../widgets/drawing_finish_button.dart';
import '../widgets/drawing_example_dialog.dart';
import '../bloc/drawing_cubit.dart';

class DrawingPage extends StatefulWidget {
  final String? selectedAnimal;
  final String? drawingMode;

  const DrawingPage({super.key, this.selectedAnimal, this.drawingMode});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final GlobalKey<DrawingCanvasState> _canvasKey =
      GlobalKey<DrawingCanvasState>();
  Uint8List? _pendingPreviewBytes;
  int? _pendingWidth;
  int? _pendingHeight;
  late Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  // Raw RGBA capture is performed inline when the user requests classification.

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showExampleDialog() async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => const DrawingExampleDialog(),
    );
  }

  String? _exampleAssetPath(String? animal) {
    switch (animal) {
      case 'Kucing':
        return 'assets/images/example/cat.png';
      case 'Sapi':
        return 'assets/images/example/cow.png';
      case 'Bebek':
        return 'assets/images/example/duck.png';
      case 'Ikan':
        return 'assets/images/example/fish.png';
      case 'Lumba-Lumba':
        return 'assets/images/example/dolphin.png';
      default:
        return null;
    }
  }

  int? _selectedAnimalIndex(String? animal) {
    switch (animal) {
      case 'Bebek':
        return 0;
      case 'Ikan':
        return 1;
      case 'Kucing':
        return 2;
      case 'Lumba-Lumba':
        return 3;
      case 'Sapi':
        return 4;
      default:
        return null;
    }
  }

  double _selectedAnimalPercent(
    List<double> rawScores,
    String? selectedAnimal,
    double fallbackPercent,
  ) {
    final index = _selectedAnimalIndex(selectedAnimal);
    if (index == null || index < 0 || index >= rawScores.length) {
      return fallbackPercent;
    }
    return (rawScores[index].clamp(0.0, 1.0)) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DrawingCubit>();
    final classificationBloc = context.read<ClassificationBloc>();
    final controller = cubit.controller;
    final showExamplePreview = widget.drawingMode == 'thicken';
    final exampleAssetPath = _exampleAssetPath(widget.selectedAnimal);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: DrawingHeader(
          title: 'Ayo Gambar ${widget.selectedAnimal ?? 'Kucing'}!',
          onBack: () => Navigator.maybePop(context),
          onExample: () {
            _showExampleDialog();
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: DrawingCanvas(
              key: _canvasKey,
              controller: controller,
              traceAssetPath: showExamplePreview ? exampleAssetPath : null,
            ),
          ),

          // Bottom-left custom controls
          Positioned(
            left: 16,
            bottom: 24,
            child: ValueListenableBuilder<Brush>(
              valueListenable: controller.brushNotifier,
              builder: (context, brush, _) {
                return DrawingBottomControls(
                  controller: controller,
                  onClear: () {
                    _canvasKey.currentState?.clear();
                    cubit.clear();
                  },
                );
              },
            ),
          ),

          // Floating finish button bottom-right
          Positioned(
            right: 16,
            bottom: 24,
            child: DrawingFinishButton(
              onPressed: () async {
                final canvasImage = await _canvasKey.currentState
                    ?.captureImage();
                if (canvasImage == null) {
                  _showSnackBar('Nothing to classify yet');
                  return;
                }

                final rawByteData = await canvasImage.toByteData(
                  format: ui.ImageByteFormat.rawRgba,
                );
                final rawImageBytes = rawByteData?.buffer.asUint8List();

                final previewByteData = await canvasImage.toByteData(
                  format: ui.ImageByteFormat.png,
                );
                final previewBytes = previewByteData?.buffer.asUint8List();

                if (rawImageBytes == null || rawImageBytes.isEmpty) {
                  _showSnackBar('Nothing to classify yet');
                  return;
                }

                _pendingPreviewBytes = previewBytes ?? rawImageBytes;
                _pendingWidth = canvasImage.width;
                _pendingHeight = canvasImage.height;

                // Keep existing classification flow
                classificationBloc.add(
                  ClassificationRequested(
                    imageBytes: rawImageBytes,
                    isRawRgba: true,
                    width: canvasImage.width,
                    height: canvasImage.height,
                  ),
                );
              },
            ),
          ),

          // Classification listener overlay
          BlocListener<ClassificationBloc, ClassificationState>(
            listener: (context, state) {
              if (state is ClassificationLoading) {
                _showSnackBar('Classifying your drawing...');
              } else if (state is ClassificationSuccess) {
                final prediction = state.prediction;
                // _showSnackBar('Prediction: ${prediction.label} ($confidence%)');
                final previewBytes = _pendingPreviewBytes;
                if (previewBytes != null && mounted) {
                  final similarityPercent = _selectedAnimalPercent(
                    prediction.rawScores,
                    widget.selectedAnimal,
                    prediction.confidence * 100,
                  );
                  context.go(
                    '/result',
                    extra: {
                      'imageBytes': previewBytes,
                      'width': _pendingWidth,
                      'height': _pendingHeight,
                      'similarityPercent': similarityPercent,
                      'animal': widget.selectedAnimal,
                      'duration': _stopwatch.elapsed.inSeconds,
                    },
                  );
                  _pendingPreviewBytes = null;
                  _pendingWidth = null;
                  _pendingHeight = null;
                }
              } else if (state is ClassificationError) {
                _showSnackBar(state.message);
              }
            },
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
