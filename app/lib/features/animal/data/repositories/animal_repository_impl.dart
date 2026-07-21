import '../../domain/entities/animal_entity.dart';
import '../../domain/repositories/animal_repository.dart';
import '../datasources/animal_remote_data_source.dart';

class AnimalRepositoryImpl implements AnimalRepository {
  final AnimalRemoteDataSource _remoteDataSource;

  const AnimalRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<AnimalEntity>> getAnimals() async {
    final models = await _remoteDataSource.getAnimals();
    return models.map((model) => model.toEntity()).toList();
  }
}
