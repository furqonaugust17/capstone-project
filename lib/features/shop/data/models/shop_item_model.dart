import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/shop_item_entity.dart';

part 'shop_item_model.g.dart';

@JsonSerializable()
class ShopItemModel {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int price;
  final ShopCategory category;
  final ShopRarity rarity;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ShopItemModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price,
    required this.category,
    required this.rarity,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShopItemModel.fromJson(Map<String, dynamic> json) =>
      _$ShopItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopItemModelToJson(this);

  ShopItemEntity toEntity() => ShopItemEntity(
        id: id,
        name: name,
        description: description,
        imageUrl: imageUrl,
        price: price,
        category: category,
        rarity: rarity,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
