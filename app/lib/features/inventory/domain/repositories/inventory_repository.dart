import '../entities/user_inventory_entity.dart';
import '../../../purchase/domain/entities/purchase_history_entity.dart';

abstract class InventoryRepository {
  Future<List<UserInventoryEntity>> getMyInventory();
  Future<List<PurchaseHistoryEntity>> getPurchaseHistory();
  Future<void> equipItem(String itemId, String category);
  Future<void> unequipItem(String category);
}
