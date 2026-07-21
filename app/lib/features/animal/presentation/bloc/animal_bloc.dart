import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_animals_usecase.dart';
import 'animal_event.dart';
import 'animal_state.dart';

class AnimalBloc extends Bloc<AnimalEvent, AnimalState> {
  final GetAnimalsUseCase _getAnimalsUseCase;

  AnimalBloc({required GetAnimalsUseCase getAnimalsUseCase})
      : _getAnimalsUseCase = getAnimalsUseCase,
        super(const AnimalInitial()) {
    on<LoadAnimals>(_onLoadAnimals);
  }

  Future<void> _onLoadAnimals(
      LoadAnimals event, Emitter<AnimalState> emit) async {
    emit(const AnimalLoading());
    try {
      final animals = await _getAnimalsUseCase();
      emit(AnimalLoaded(animals));
    } catch (e) {
      emit(AnimalError(e.toString().replaceFirst(RegExp(r'^.*?Exception: '), '')));
    }
  }
}
