// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseHistoryModel _$PurchaseHistoryModelFromJson(
  Map<String, dynamic> json,
) => PurchaseHistoryModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  shopItemId: json['shopItemId'] as String,
  priceAtPurchase: (json['priceAtPurchase'] as num).toInt(),
  purchasedAt: DateTime.parse(json['purchasedAt'] as String),
  shopItem: json['shopItem'] == null
      ? null
      : ShopItemModel.fromJson(json['shopItem'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PurchaseHistoryModelToJson(
  PurchaseHistoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'shopItemId': instance.shopItemId,
  'priceAtPurchase': instance.priceAtPurchase,
  'purchasedAt': instance.purchasedAt.toIso8601String(),
  'shopItem': instance.shopItem,
};
