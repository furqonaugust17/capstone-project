import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/purchase_history_entity.dart';
import '../../../shop/data/models/shop_item_model.dart';

part 'purchase_history_model.g.dart';

@JsonSerializable()
class PurchaseHistoryModel {
  final String id;
  final String userId;
  final String shopItemId;
  final int priceAtPurchase;
  final DateTime purchasedAt;
  final ShopItemModel? shopItem;

  const PurchaseHistoryModel({
    required this.id,
    required this.userId,
    required this.shopItemId,
    required this.priceAtPurchase,
    required this.purchasedAt,
    this.shopItem,
  });

  factory PurchaseHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseHistoryModelToJson(this);

  PurchaseHistoryEntity toEntity() => PurchaseHistoryEntity(
        id: id,
        userId: userId,
        shopItemId: shopItemId,
        priceAtPurchase: priceAtPurchase,
        purchasedAt: purchasedAt,
        shopItem: shopItem?.toEntity(),
      );
}
