import '../../domain/entities/user_inventory_entity.dart';
import '../../../purchase/domain/entities/purchase_history_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_remote_data_source.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource _remoteDataSource;

  InventoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<UserInventoryEntity>> getMyInventory() async {
    final models = await _remoteDataSource.getMyInventory();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<PurchaseHistoryEntity>> getPurchaseHistory() async {
    final models = await _remoteDataSource.getPurchaseHistory();
    return models.map((e) => e.toEntity()).toList();
  }
}
