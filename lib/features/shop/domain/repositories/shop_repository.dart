import '../../../../core/network/models/paginated_response.dart';
import '../entities/shop_item_entity.dart';

abstract class ShopRepository {
  Future<PaginatedResponse<ShopItemEntity>> getShopItems({
    int page = 1,
    int limit = 10,
    ShopCategory? category,
    ShopRarity? rarity,
  });

  Future<ShopItemEntity> getShopItemDetail(String id);
}
