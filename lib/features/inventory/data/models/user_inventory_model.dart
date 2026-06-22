import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_inventory_entity.dart';
import '../../../shop/data/models/shop_item_model.dart';

part 'user_inventory_model.g.dart';

@JsonSerializable()
class UserInventoryModel {
  final String id;
  final String userId;
  final String shopItemId;
  final DateTime acquiredAt;
  final ShopItemModel? shopItem;

  const UserInventoryModel({
    required this.id,
    required this.userId,
    required this.shopItemId,
    required this.acquiredAt,
    this.shopItem,
  });

  factory UserInventoryModel.fromJson(Map<String, dynamic> json) =>
      _$UserInventoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserInventoryModelToJson(this);

  UserInventoryEntity toEntity() => UserInventoryEntity(
        id: id,
        shopItemId: shopItemId,
        itemName: shopItem?.name ?? 'Unknown Item',
        itemImageUrl: shopItem?.imageUrl,
        category: shopItem?.category.name ?? 'UNKNOWN',
        rarity: shopItem?.rarity.name ?? 'COMMON',
        acquiredAt: acquiredAt,
      );
}
