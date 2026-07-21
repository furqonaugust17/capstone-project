import 'package:equatable/equatable.dart';
import '../../domain/entities/user_inventory_entity.dart';
import '../../../purchase/domain/entities/purchase_history_entity.dart';

sealed class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<UserInventoryEntity> items;

  const InventoryLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class PurchaseHistoryLoaded extends InventoryState {
  final List<PurchaseHistoryEntity> history;

  const PurchaseHistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class InventoryError extends InventoryState {
  final String message;

  const InventoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class EquipSuccess extends InventoryState {
  final String itemId;
  final String category;

  const EquipSuccess(this.itemId, this.category);

  @override
  List<Object?> get props => [itemId, category];
}

class UnequipSuccess extends InventoryState {
  final String category;

  const UnequipSuccess(this.category);

  @override
  List<Object?> get props => [category];
}
