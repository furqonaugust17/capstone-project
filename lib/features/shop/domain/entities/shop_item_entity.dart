import 'package:equatable/equatable.dart';

enum ShopCategory { AVATAR, FRAME, STICKER, THEME }
enum ShopRarity { COMMON, RARE, EPIC, LEGENDARY }

class ShopItemEntity extends Equatable {
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

  const ShopItemEntity({
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

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        price,
        category,
        rarity,
        isActive,
        createdAt,
        updatedAt,
      ];
}
