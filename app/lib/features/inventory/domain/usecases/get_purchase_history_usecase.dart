import '../../../purchase/domain/entities/purchase_history_entity.dart';
import '../repositories/inventory_repository.dart';

class GetPurchaseHistoryUseCase {
  final InventoryRepository _repository;

  GetPurchaseHistoryUseCase(this._repository);

  Future<List<PurchaseHistoryEntity>> call() {
    return _repository.getPurchaseHistory();
  }
}
