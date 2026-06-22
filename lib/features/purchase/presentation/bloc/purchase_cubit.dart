import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/exceptions/network_exception.dart';
import '../../domain/usecases/buy_item_usecase.dart';
import 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final BuyItemUseCase _buyItemUseCase;

  PurchaseCubit(this._buyItemUseCase) : super(PurchaseInitial());

  Future<void> buyItem(String itemId) async {
    emit(PurchaseLoading());
    try {
      final purchase = await _buyItemUseCase(itemId);
      emit(PurchaseSuccess(purchase));
    } on NetworkException catch (e) {
      emit(PurchaseError(e.message));
    } catch (e) {
      emit(PurchaseError(e.toString()));
    }
  }

  void reset() {
    emit(PurchaseInitial());
  }
}
