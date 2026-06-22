import '../../../../core/network/models/paginated_response.dart';
import '../entities/shop_item_entity.dart';
import '../repositories/shop_repository.dart';

class GetShopItemsUseCase {
  final ShopRepository _repository;

  GetShopItemsUseCase(this._repository);

  Future<PaginatedResponse<ShopItemEntity>> call({
    int page = 1,
    int limit = 10,
    ShopCategory? category,
    ShopRarity? rarity,
  }) {
    return _repository.getShopItems(
      page: page,
      limit: limit,
      category: category,
      rarity: rarity,
    );
  }
}
