part of 'drawing_cubit.dart';

abstract class DrawingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DrawingInitial extends DrawingState {}

class DrawingLoading extends DrawingState {}

class DrawingSaved extends DrawingState {}

class DrawingLoaded extends DrawingState {
  final List<Stroke> strokes;
  DrawingLoaded({required this.strokes});
  @override
  List<Object?> get props => [strokes];
}

class DrawingCleared extends DrawingState {}

class DrawingUpdated extends DrawingState {
  final List<Stroke> strokes;
  DrawingUpdated({required this.strokes});
  @override
  List<Object?> get props => [strokes];
}

class DrawingBrushUpdated extends DrawingState {
  final dynamic brush;
  DrawingBrushUpdated({required this.brush});
  @override
  List<Object?> get props => [brush];
}

class DrawingSelectedAnimalUpdated extends DrawingState {
  final String? animal;
  DrawingSelectedAnimalUpdated({required this.animal});
  @override
  List<Object?> get props => [animal];
}

class DrawingError extends DrawingState {
  final String message;
  DrawingError({required this.message});
  @override
  List<Object?> get props => [message];
}
