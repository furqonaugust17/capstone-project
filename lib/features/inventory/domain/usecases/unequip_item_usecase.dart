import '../repositories/inventory_repository.dart';

class UnequipItemUseCase {
  final InventoryRepository _repository;

  UnequipItemUseCase(this._repository);

  Future<void> call(String category) {
    return _repository.unequipItem(category);
  }
}
