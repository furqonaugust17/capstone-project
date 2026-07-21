import 'package:get_it/get_it.dart';
import 'data/datasources/animal_remote_data_source.dart';
import 'data/repositories/animal_repository_impl.dart';
import 'domain/repositories/animal_repository.dart';
import 'domain/usecases/get_animals_usecase.dart';
import 'presentation/bloc/animal_bloc.dart';

Future<void> initAnimalFeature(GetIt di) async {
  // Data sources
  di.registerLazySingleton<AnimalRemoteDataSource>(
    () => AnimalRemoteDataSourceImpl(di()),
  );

  // Repository
  di.registerLazySingleton<AnimalRepository>(
    () => AnimalRepositoryImpl(di()),
  );

  // Use cases
  di.registerLazySingleton(() => GetAnimalsUseCase(di()));

  // BLoC
  di.registerFactory(() => AnimalBloc(getAnimalsUseCase: di()));
}
