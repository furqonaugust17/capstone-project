import 'package:get_it/get_it.dart';
import 'package:app/core/network/api_client.dart';
import 'data/datasources/inventory_remote_data_source.dart';
import 'data/repositories/inventory_repository_impl.dart';
import 'domain/repositories/inventory_repository.dart';
import 'domain/usecases/get_my_inventory_usecase.dart';
import 'domain/usecases/get_purchase_history_usecase.dart';
import 'presentation/bloc/inventory_cubit.dart';

Future<void> initInventoryFeature(GetIt di) async {
  // Data sources
  di.registerLazySingleton<InventoryRemoteDataSource>(
    () => InventoryRemoteDataSourceImpl(di<ApiClient>()),
  );

  // Repositories
  di.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(di<InventoryRemoteDataSource>()),
  );

  // Use cases
  di.registerLazySingleton(() => GetMyInventoryUseCase(di<InventoryRepository>()));
  di.registerLazySingleton(() => GetPurchaseHistoryUseCase(di<InventoryRepository>()));

  // Blocs
  di.registerFactory(() => InventoryCubit(di<GetMyInventoryUseCase>(), di<GetPurchaseHistoryUseCase>()));
}
