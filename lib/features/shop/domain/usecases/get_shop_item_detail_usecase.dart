import '../entities/shop_item_entity.dart';
import '../repositories/shop_repository.dart';

class GetShopItemDetailUseCase {
  final ShopRepository _repository;

  GetShopItemDetailUseCase(this._repository);

  Future<ShopItemEntity> call(String id) {
    return _repository.getShopItemDetail(id);
  }
}
