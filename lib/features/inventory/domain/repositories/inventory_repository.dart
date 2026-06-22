import '../entities/user_inventory_entity.dart';
import '../../../purchase/domain/entities/purchase_history_entity.dart';

abstract class InventoryRepository {
  Future<List<UserInventoryEntity>> getMyInventory();
  Future<List<PurchaseHistoryEntity>> getPurchaseHistory();
}
