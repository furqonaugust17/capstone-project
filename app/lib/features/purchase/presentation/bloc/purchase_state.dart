import 'package:equatable/equatable.dart';
import '../../domain/entities/purchase_history_entity.dart';

sealed class PurchaseState extends Equatable {
  const PurchaseState();

  @override
  List<Object> get props => [];
}

class PurchaseInitial extends PurchaseState {}

class PurchaseLoading extends PurchaseState {}

class PurchaseSuccess extends PurchaseState {
  final PurchaseHistoryEntity purchase;

  const PurchaseSuccess(this.purchase);

  @override
  List<Object> get props => [purchase];
}

class PurchaseError extends PurchaseState {
  final String message;

  const PurchaseError(this.message);

  @override
  List<Object> get props => [message];
}
