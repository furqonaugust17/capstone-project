import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/core/theme/app_colors.dart';
import 'package:app/features/game_session/presentation/bloc/submit/submit_game_cubit.dart';
import 'package:app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:app/features/auth/presentation/bloc/auth_event.dart';

import '../sections/result_scene_section.dart';

class ResultPage extends StatefulWidget {
  final Uint8List? imageBytes;
  final int? srcWidth;
  final int? srcHeight;
  final double? similarityPercent;
  final dynamic selectedAnimal; // AnimalEntity
  final int? duration;
  final String? predictionLabel;
  final double? confidenceScore;
  final DateTime? startedAt;

  const ResultPage({
    super.key,
    this.imageBytes,
    this.srcWidth,
    this.srcHeight,
    this.similarityPercent,
    this.selectedAnimal,
    this.duration,
    this.predictionLabel,
    this.confidenceScore,
    this.startedAt,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    super.initState();
    if (widget.selectedAnimal != null && widget.predictionLabel != null && widget.startedAt != null) {
      context.read<SubmitGameCubit>().submitResult(
            animal: widget.selectedAnimal,
            predictionLabel: widget.predictionLabel!,
            confidenceScore: widget.confidenceScore ?? 0.0,
            drawingDuration: widget.duration ?? 0,
            startedAt: widget.startedAt!,
            imageBytes: widget.imageBytes,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<SubmitGameCubit, SubmitGameState>(
        listener: (context, state) {
          if (state is SubmitGameError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save score: ${state.message}')),
            );
          } else if (state is SubmitGameSuccess) {
             // Refresh user data so total points are updated!
             context.read<AuthBloc>().add(const AuthCheckRequested());
          }
        },
        builder: (context, state) {
          return Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ResultSceneSection(
                    imageBytes: widget.imageBytes,
                    similarityPercent: widget.similarityPercent,
                    selectedAnimal: widget.selectedAnimal?.name ?? widget.selectedAnimal?.toString(),
                    duration: widget.duration,
                    gameScore: state is SubmitGameSuccess ? state.session.gameScore : null,
                  ),
                  if (state is SubmitGameLoading)
                    Container(
                      width: 917.0,
                      height: 412.0,
                      color: Colors.black.withValues(alpha: 0.3),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
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
