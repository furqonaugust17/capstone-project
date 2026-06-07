import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/stroke.dart';
import '../../domain/entities/brush.dart';
import '../../domain/usecases/save_drawing_usecase.dart';
import '../../domain/usecases/load_drawing_usecase.dart';
import '../../domain/usecases/clear_drawing_usecase.dart';
import '../controllers/drawing_controller.dart';

part 'drawing_state.dart';

class DrawingCubit extends Cubit<DrawingState> {
  final DrawingController controller;
  final SaveDrawingUseCase saveUseCase;
  final LoadDrawingUseCase loadUseCase;
  final ClearDrawingUseCase clearUseCase;
  String? selectedAnimal;

  DrawingCubit({
    required this.controller,
    required this.saveUseCase,
    required this.loadUseCase,
    required this.clearUseCase,
  }) : super(DrawingInitial()) {
    // Optionally listen to controller changes for persistence or state syncing
  }

  void setSelectedAnimal(String? animal) {
    selectedAnimal = animal;
    emit(DrawingSelectedAnimalUpdated(animal: animal));
  }

  Future<void> save({String? id}) async {
    emit(DrawingLoading());
    try {
      await saveUseCase(controller.strokes.value, id: id);
      emit(DrawingSaved());
    } catch (e) {
      emit(DrawingError(message: e.toString()));
    }
  }

  Future<void> load({String? id}) async {
    emit(DrawingLoading());
    try {
      final loaded = await loadUseCase(id: id);
      controller.strokes.value = loaded;
      emit(DrawingLoaded(strokes: loaded));
    } catch (e) {
      emit(DrawingError(message: e.toString()));
    }
  }

  Future<void> clear({String? id}) async {
    emit(DrawingLoading());
    try {
      await clearUseCase(id: id);
      controller.clear();
      emit(DrawingCleared());
    } catch (e) {
      emit(DrawingError(message: e.toString()));
    }
  }

  void undo() {
    controller.undo();
    emit(DrawingUpdated(strokes: controller.strokes.value));
  }

  void setBrush(Brush brush) {
    controller.setBrush(brush);
    emit(DrawingBrushUpdated(brush: brush));
  }
}
