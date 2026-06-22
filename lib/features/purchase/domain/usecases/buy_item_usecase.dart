import '../entities/purchase_history_entity.dart';
import '../repositories/purchase_repository.dart';

class BuyItemUseCase {
  final PurchaseRepository _repository;

  BuyItemUseCase(this._repository);

  Future<PurchaseHistoryEntity> call(String itemId) {
    return _repository.buyItem(itemId);
  }
}
