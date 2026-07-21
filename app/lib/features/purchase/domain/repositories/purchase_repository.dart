import '../entities/purchase_history_entity.dart';

abstract class PurchaseRepository {
  Future<PurchaseHistoryEntity> buyItem(String itemId);
}
