import '../entities/animal_entity.dart';

abstract class AnimalRepository {
  Future<List<AnimalEntity>> getAnimals();
}
