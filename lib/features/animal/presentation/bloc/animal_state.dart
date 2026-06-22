import 'package:equatable/equatable.dart';
import '../../domain/entities/animal_entity.dart';

sealed class AnimalState extends Equatable {
  const AnimalState();

  @override
  List<Object?> get props => [];
}

class AnimalInitial extends AnimalState {
  const AnimalInitial();
}

class AnimalLoading extends AnimalState {
  const AnimalLoading();
}

class AnimalLoaded extends AnimalState {
  final List<AnimalEntity> animals;

  const AnimalLoaded(this.animals);

  @override
  List<Object?> get props => [animals];
}

class AnimalError extends AnimalState {
  final String message;

  const AnimalError(this.message);

  @override
  List<Object?> get props => [message];
}
