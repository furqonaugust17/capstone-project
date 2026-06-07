part of 'classification_bloc.dart';

abstract class ClassificationState extends Equatable {
  const ClassificationState();

  @override
  List<Object?> get props => const <Object?>[];
}

class ClassificationInitial extends ClassificationState {
  const ClassificationInitial();
}

class ClassificationLoading extends ClassificationState {
  const ClassificationLoading();
}

class ClassificationReady extends ClassificationState {
  const ClassificationReady();
}

class ClassificationSuccess extends ClassificationState {
  final PredictionEntity prediction;

  const ClassificationSuccess(this.prediction);

  @override
  List<Object?> get props => <Object?>[prediction];
}

class ClassificationError extends ClassificationState {
  final String message;

  const ClassificationError(this.message);

  @override
  List<Object?> get props => <Object?>[message];
}
