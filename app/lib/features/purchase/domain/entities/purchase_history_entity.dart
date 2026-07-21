import 'package:equatable/equatable.dart';
import '../../../shop/domain/entities/shop_item_entity.dart';

class PurchaseHistoryEntity extends Equatable {
  final String id;
  final String userId;
  final String shopItemId;
  final int priceAtPurchase;
  final DateTime purchasedAt;
  final ShopItemEntity? shopItem;

  const PurchaseHistoryEntity({
    required this.id,
    required this.userId,
    required this.shopItemId,
    required this.priceAtPurchase,
    required this.purchasedAt,
    this.shopItem,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        shopItemId,
        priceAtPurchase,
        purchasedAt,
        shopItem,
      ];
}
