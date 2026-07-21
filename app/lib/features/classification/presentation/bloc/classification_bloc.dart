import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/prediction_entity.dart';
import '../../domain/usecases/classify_sketch_usecase.dart';

part 'classification_event.dart';
part 'classification_state.dart';

class ClassificationBloc
    extends Bloc<ClassificationEvent, ClassificationState> {
  final ClassifySketchUseCase _classifySketchUseCase;

  ClassificationBloc(this._classifySketchUseCase)
    : super(const ClassificationInitial()) {
    on<ClassificationWarmUpRequested>(_onWarmUpRequested);
    on<ClassificationRequested>(_onClassificationRequested);
    on<ClassificationResetRequested>(_onResetRequested);
  }

  Future<void> _onWarmUpRequested(
    ClassificationWarmUpRequested event,
    Emitter<ClassificationState> emit,
  ) async {
    emit(const ClassificationLoading());
    try {
      await _classifySketchUseCase.warmUpModel();
      emit(const ClassificationReady());
    } catch (error) {
      emit(ClassificationError(error.toString()));
    }
  }

  Future<void> _onClassificationRequested(
    ClassificationRequested event,
    Emitter<ClassificationState> emit,
  ) async {
    emit(const ClassificationLoading());
    try {
      final prediction = await _classifySketchUseCase(
        ClassifySketchParams(
          imageBytes: event.imageBytes,
          forceGrayscale: event.forceGrayscale,
          isRawRgba: event.isRawRgba,
          width: event.width,
          height: event.height,
        ),
      );
      emit(ClassificationSuccess(prediction));
    } catch (error) {
      emit(ClassificationError(error.toString()));
    }
  }

  void _onResetRequested(
    ClassificationResetRequested event,
    Emitter<ClassificationState> emit,
  ) {
    emit(const ClassificationInitial());
  }
}
