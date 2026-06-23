import 'package:get_it/get_it.dart';
import 'package:app/core/network/api_client.dart';
import 'data/datasources/purchase_remote_data_source.dart';
import 'data/repositories/purchase_repository_impl.dart';
import 'domain/repositories/purchase_repository.dart';
import 'domain/usecases/buy_item_usecase.dart';
import 'presentation/bloc/purchase_cubit.dart';

Future<void> initPurchaseFeature(GetIt di) async {
  // Data sources
  di.registerLazySingleton<PurchaseRemoteDataSource>(
    () => PurchaseRemoteDataSourceImpl(di<ApiClient>()),
  );

  // Repositories
  di.registerLazySingleton<PurchaseRepository>(
    () => PurchaseRepositoryImpl(di<PurchaseRemoteDataSource>()),
  );

  // Use cases
  di.registerLazySingleton(() => BuyItemUseCase(di<PurchaseRepository>()));

  // Blocs
  di.registerFactory(() => PurchaseCubit(di<BuyItemUseCase>()));
}
