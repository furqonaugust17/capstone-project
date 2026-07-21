import 'package:equatable/equatable.dart';
import '../../domain/entities/shop_item_entity.dart';

sealed class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object?> get props => [];
}

class ShopInitial extends ShopState {}

class ShopLoading extends ShopState {
  final bool isFirstFetch;

  const ShopLoading({this.isFirstFetch = false});

  @override
  List<Object?> get props => [isFirstFetch];
}

class ShopLoaded extends ShopState {
  final List<ShopItemEntity> items;
  final bool hasReachedMax;
  final ShopCategory? selectedCategory;
  final ShopRarity? selectedRarity;

  const ShopLoaded({
    required this.items,
    required this.hasReachedMax,
    this.selectedCategory,
    this.selectedRarity,
  });

  ShopLoaded copyWith({
    List<ShopItemEntity>? items,
    bool? hasReachedMax,
    ShopCategory? selectedCategory,
    ShopRarity? selectedRarity,
    bool clearCategory = false,
    bool clearRarity = false,
  }) {
    return ShopLoaded(
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedRarity: clearRarity ? null : (selectedRarity ?? this.selectedRarity),
    );
  }

  @override
  List<Object?> get props => [items, hasReachedMax, selectedCategory, selectedRarity];
}

class ShopError extends ShopState {
  final String message;

  const ShopError(this.message);

  @override
  List<Object?> get props => [message];
}
