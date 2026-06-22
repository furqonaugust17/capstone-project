import 'package:equatable/equatable.dart';

class UserInventoryEntity extends Equatable {
  final String id;
  final String shopItemId;
  final String itemName;
  final String? itemImageUrl;
  final String category;
  final String rarity;
  final DateTime acquiredAt;

  const UserInventoryEntity({
    required this.id,
    required this.shopItemId,
    required this.itemName,
    this.itemImageUrl,
    required this.category,
    required this.rarity,
    required this.acquiredAt,
  });

  @override
  List<Object?> get props => [
        id,
        shopItemId,
        itemName,
        itemImageUrl,
        category,
        rarity,
        acquiredAt,
      ];
}
