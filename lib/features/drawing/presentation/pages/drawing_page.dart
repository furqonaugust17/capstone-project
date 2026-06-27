import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/features/classification/presentation/bloc/classification_bloc.dart';
import 'package:app/features/drawing/presentation/bloc/focus/focus_cubit.dart';

import '../widgets/drawing_canvas.dart';
import 'package:app/shared/widgets/custom_app_bar.dart';
import '../../domain/entities/brush.dart';
import '../widgets/drawing_bottom_controls.dart';
import '../widgets/drawing_finish_button.dart';
import '../widgets/drawing_example_dialog.dart';
import '../bloc/drawing_cubit.dart';

class DrawingPage extends StatefulWidget {
  final dynamic selectedAnimalEntity;
  final String? drawingMode;

  const DrawingPage({super.key, this.selectedAnimalEntity, this.drawingMode});

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
      builder: (dialogContext) => DrawingExampleDialog(
        imagePath: widget.selectedAnimalEntity?.hintImageUrl ?? _exampleAssetPath(widget.selectedAnimalEntity?.name),
        funFact: widget.selectedAnimalEntity?.description,
      ),
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
      case 'Lumba-lumba':
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

  /// Returns the trace image opacity that matches the current [FocusLevel].
  /// Higher opacity = hint becomes more visible when focus drops.
  double _traceOpacityForFocus(FocusLevel level) {
    switch (level) {
      case FocusLevel.high:
        return 0.35;
      case FocusLevel.medium:
        return 0.45;
      case FocusLevel.low:
        return 0.65;
      case FocusLevel.veryLow:
        return 0.80;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DrawingCubit>();
    final classificationBloc = context.read<ClassificationBloc>();
    final controller = cubit.controller;
    final showExamplePreview = widget.drawingMode == 'thicken';
    final exampleAssetPath = _exampleAssetPath(widget.selectedAnimalEntity?.name);

    return BlocProvider<FocusCubit>(
      create: (_) => FocusCubit(),
      child: Builder(
        builder: (focusContext) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Ayo Gambar ${widget.selectedAnimalEntity?.name ?? 'Kucing'}!',
              actions: [
                GestureDetector(
                  onTap: _showExampleDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16, // AppSpacing.md
                      vertical: 4,  // AppSpacing.xs
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3FA), // AppColors.surface
                      borderRadius: BorderRadius.circular(24), // AppRadius.xl
                      border: Border.all(color: const Color(0xFFE0E0E0)), // AppColors.border
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0xFF4285F4), // AppColors.primary
                          child: Icon(
                            Icons.pets,
                            color: Colors.white, // AppColors.textOnPrimary
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8), // AppSpacing.sm
                        const Text(
                          'CONTOH',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF4285F4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: BlocListener<FocusCubit, FocusState>(
              listener: (ctx, focusState) {
                // Show motivational nudge whenever a new message is emitted
                if (focusState.motivationalMessage != null) {
                  _showSnackBar(focusState.motivationalMessage!);
                  // Auto-clear the message after showing so the next level
                  // change can trigger a new one.
                  Future.delayed(const Duration(seconds: 3), () {
                    if (focusContext.mounted) {
                      focusContext.read<FocusCubit>().clearMessage();
                    }
                  });
                }
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Listener placed as first child to capture pointer events
                  // across the entire area, without interfering with Positioned
                  // widgets that must be direct children of Stack.
                  Listener(
                    behavior: HitTestBehavior.translucent,
                    onPointerDown: (_) =>
                        focusContext.read<FocusCubit>().resetFocusTimer(),
                    onPointerMove: (_) =>
                        focusContext.read<FocusCubit>().resetFocusTimer(),
                    child: const SizedBox.expand(),
                  ),

                  // Drawing canvas with adaptive trace opacity
                  BlocBuilder<FocusCubit, FocusState>(
                    builder: (ctx, focusState) {
                      final opacity = _traceOpacityForFocus(focusState.level);
                      return Positioned.fill(
                        child: DrawingCanvas(
                          key: _canvasKey,
                          controller: controller,
                          traceAssetPath:
                              showExamplePreview ? exampleAssetPath : null,
                          traceOpacity: opacity,
                        ),
                      );
                    },
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
                        final canvasImage =
                            await _canvasKey.currentState?.captureImage();
                        if (canvasImage == null) {
                          _showSnackBar('Nothing to classify yet');
                          return;
                        }

                        final rawByteData = await canvasImage.toByteData(
                          format: ui.ImageByteFormat.rawRgba,
                        );
                        final rawImageBytes =
                            rawByteData?.buffer.asUint8List();

                        final previewByteData = await canvasImage.toByteData(
                          format: ui.ImageByteFormat.png,
                        );
                        final previewBytes =
                            previewByteData?.buffer.asUint8List();

                        if (rawImageBytes == null || rawImageBytes.isEmpty) {
                          _showSnackBar('Nothing to classify yet');
                          return;
                        }

                        _pendingPreviewBytes = previewBytes ?? rawImageBytes;
                        _pendingWidth = canvasImage.width;
                        _pendingHeight = canvasImage.height;

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

                  // Classification result listener — navigates to result page
                  BlocListener<ClassificationBloc, ClassificationState>(
                    listener: (context, state) {
                      if (state is ClassificationLoading) {
                        _showSnackBar('Classifying your drawing...');
                      } else if (state is ClassificationSuccess) {
                        final prediction = state.prediction;
                        final previewBytes = _pendingPreviewBytes;
                        if (previewBytes != null && mounted) {
                          final similarityPercent = _selectedAnimalPercent(
                            prediction.rawScores,
                            widget.selectedAnimalEntity?.name,
                            prediction.confidence * 100,
                          );
                          context.go(
                            '/result',
                            extra: {
                              'imageBytes': previewBytes,
                              'width': _pendingWidth,
                              'height': _pendingHeight,
                              'similarityPercent': similarityPercent,
                              'animal': widget.selectedAnimalEntity, // pass full entity
                              'predictionLabel': prediction.label,
                              'confidenceScore': prediction.confidence,
                              'duration': _stopwatch.elapsed.inSeconds,
                              // Actually startedAt should be when we loaded the page, or when drawing starts.
                              // Since we start the stopwatch at initState, we can use now() - stopwatch
                              'startedAt': DateTime.now().subtract(_stopwatch.elapsed),
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
            ),
          );
        },
      ),
    );
  }
}
