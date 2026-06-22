// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopItemModel _$ShopItemModelFromJson(Map<String, dynamic> json) =>
    ShopItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num).toInt(),
      category: $enumDecode(_$ShopCategoryEnumMap, json['category']),
      rarity: $enumDecode(_$ShopRarityEnumMap, json['rarity']),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ShopItemModelToJson(ShopItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'category': _$ShopCategoryEnumMap[instance.category]!,
      'rarity': _$ShopRarityEnumMap[instance.rarity]!,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ShopCategoryEnumMap = {
  ShopCategory.AVATAR: 'AVATAR',
  ShopCategory.FRAME: 'FRAME',
  ShopCategory.STICKER: 'STICKER',
  ShopCategory.THEME: 'THEME',
};

const _$ShopRarityEnumMap = {
  ShopRarity.COMMON: 'COMMON',
  ShopRarity.RARE: 'RARE',
  ShopRarity.EPIC: 'EPIC',
  ShopRarity.LEGENDARY: 'LEGENDARY',
};
