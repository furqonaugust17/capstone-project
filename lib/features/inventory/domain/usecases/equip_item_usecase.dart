import '../repositories/inventory_repository.dart';

class EquipItemUseCase {
  final InventoryRepository _repository;

  EquipItemUseCase(this._repository);

  Future<void> call(String itemId, String category) {
    return _repository.equipItem(itemId, category);
  }
}
