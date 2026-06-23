import 'package:get_it/get_it.dart';
import 'package:app/core/network/api_client.dart';
import 'data/datasources/shop_remote_data_source.dart';
import 'data/repositories/shop_repository_impl.dart';
import 'domain/repositories/shop_repository.dart';
import 'domain/usecases/get_shop_item_detail_usecase.dart';
import 'domain/usecases/get_shop_items_usecase.dart';
import 'presentation/bloc/shop_cubit.dart';

Future<void> initShopFeature(GetIt di) async {
  // Data sources
  di.registerLazySingleton<ShopRemoteDataSource>(
    () => ShopRemoteDataSourceImpl(di<ApiClient>()),
  );

  // Repositories
  di.registerLazySingleton<ShopRepository>(
    () => ShopRepositoryImpl(di<ShopRemoteDataSource>()),
  );

  // Use cases
  di.registerLazySingleton(() => GetShopItemsUseCase(di<ShopRepository>()));
  di.registerLazySingleton(() => GetShopItemDetailUseCase(di<ShopRepository>()));

  // Blocs
  di.registerFactory(() => ShopCubit(di<GetShopItemsUseCase>()));
}
