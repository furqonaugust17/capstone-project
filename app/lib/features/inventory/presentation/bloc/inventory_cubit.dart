import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_inventory_usecase.dart';
import '../../domain/usecases/get_purchase_history_usecase.dart';
import '../../domain/usecases/equip_item_usecase.dart';
import '../../domain/usecases/unequip_item_usecase.dart';
import 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final GetMyInventoryUseCase _getMyInventoryUseCase;
  final GetPurchaseHistoryUseCase _getPurchaseHistoryUseCase;
  final EquipItemUseCase _equipItemUseCase;
  final UnequipItemUseCase _unequipItemUseCase;

  InventoryCubit(
    this._getMyInventoryUseCase,
    this._getPurchaseHistoryUseCase,
    this._equipItemUseCase,
    this._unequipItemUseCase,
  ) : super(InventoryInitial());

  Future<void> fetchInventory() async {
    emit(InventoryLoading());
    try {
      final items = await _getMyInventoryUseCase();
      emit(InventoryLoaded(items));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> fetchPurchaseHistory() async {
    emit(InventoryLoading());
    try {
      final history = await _getPurchaseHistoryUseCase();
      emit(PurchaseHistoryLoaded(history));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> equipItem(String itemId, String category) async {
    final currentState = state;
    emit(InventoryLoading());
    try {
      await _equipItemUseCase(itemId, category);
      emit(EquipSuccess(itemId, category));
      // Revert back to the current state or refetch
      if (currentState is InventoryLoaded) {
        emit(currentState);
      } else {
        fetchInventory();
      }
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> unequipItem(String category) async {
    final currentState = state;
    emit(InventoryLoading());
    try {
      await _unequipItemUseCase(category);
      emit(UnequipSuccess(category));
      if (currentState is InventoryLoaded) {
        emit(currentState);
      } else {
        fetchInventory();
      }
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }
}
