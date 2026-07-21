// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInventoryModel _$UserInventoryModelFromJson(Map<String, dynamic> json) =>
    UserInventoryModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      shopItemId: json['itemId'] as String,
      acquiredAt: DateTime.parse(json['acquiredAt'] as String),
      shopItem: json['shopItem'] == null
          ? null
          : ShopItemModel.fromJson(json['shopItem'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserInventoryModelToJson(UserInventoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'itemId': instance.shopItemId,
      'acquiredAt': instance.acquiredAt.toIso8601String(),
      'shopItem': instance.shopItem,
    };
