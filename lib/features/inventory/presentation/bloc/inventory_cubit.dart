import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_inventory_usecase.dart';
import '../../domain/usecases/get_purchase_history_usecase.dart';
import 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final GetMyInventoryUseCase _getMyInventoryUseCase;
  final GetPurchaseHistoryUseCase _getPurchaseHistoryUseCase;

  InventoryCubit(this._getMyInventoryUseCase, this._getPurchaseHistoryUseCase) : super(InventoryInitial());

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
}
