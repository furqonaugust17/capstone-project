import '../../../../core/network/models/paginated_response.dart';
import '../../domain/entities/shop_item_entity.dart';
import '../../domain/repositories/shop_repository.dart';
import '../datasources/shop_remote_data_source.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopRemoteDataSource _remoteDataSource;

  ShopRepositoryImpl(this._remoteDataSource);

  @override
  Future<PaginatedResponse<ShopItemEntity>> getShopItems({
    int page = 1,
    int limit = 10,
    ShopCategory? category,
    ShopRarity? rarity,
  }) async {
    final paginatedModels = await _remoteDataSource.getShopItems(
      page: page,
      limit: limit,
      category: category,
      rarity: rarity,
    );

    return PaginatedResponse<ShopItemEntity>(
      data: paginatedModels.data.map((m) => m.toEntity()).toList(),
      meta: paginatedModels.meta,
    );
  }

  @override
  Future<ShopItemEntity> getShopItemDetail(String id) async {
    final model = await _remoteDataSource.getShopItemDetail(id);
    return model.toEntity();
  }
}
