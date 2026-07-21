import '../entities/animal_entity.dart';
import '../repositories/animal_repository.dart';

class GetAnimalsUseCase {
  final AnimalRepository _repository;

  const GetAnimalsUseCase(this._repository);

  Future<List<AnimalEntity>> call() {
    return _repository.getAnimals();
  }
}
