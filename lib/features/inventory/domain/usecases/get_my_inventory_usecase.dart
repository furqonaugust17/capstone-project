import '../entities/user_inventory_entity.dart';
import '../repositories/inventory_repository.dart';

class GetMyInventoryUseCase {
  final InventoryRepository _repository;

  GetMyInventoryUseCase(this._repository);

  Future<List<UserInventoryEntity>> call() {
    return _repository.getMyInventory();
  }
}
