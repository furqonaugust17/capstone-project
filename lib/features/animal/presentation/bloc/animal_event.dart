import 'package:equatable/equatable.dart';

sealed class AnimalEvent extends Equatable {
  const AnimalEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnimals extends AnimalEvent {
  const LoadAnimals();
}
