import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/shared/widgets/custom_app_bar.dart';
import 'package:app/features/shop/domain/entities/shop_item_entity.dart';
import 'package:app/features/purchase/presentation/bloc/purchase_cubit.dart';
import 'package:app/features/purchase/presentation/bloc/purchase_state.dart';
import 'package:app/injection/injection.dart';
import 'package:go_router/go_router.dart';
import 'package:app/features/auth/presentation/bloc/auth_bloc.dart' as app_auth;
import 'package:app/features/auth/presentation/bloc/auth_event.dart'
    as app_auth;

import 'package:app/features/inventory/presentation/bloc/inventory_cubit.dart';
import 'package:app/features/inventory/presentation/bloc/inventory_state.dart';

class ShopItemDetailPage extends StatelessWidget {
  final ShopItemEntity item;

  const ShopItemDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di<PurchaseCubit>()),
        BlocProvider(create: (context) => di<InventoryCubit>()..fetchInventory()),
      ],
      child: _ShopItemDetailView(item: item),
    );
  }
}

class _ShopItemDetailView extends StatelessWidget {
  final ShopItemEntity item;

  const _ShopItemDetailView({required this.item});

  Color getRarityColor(ShopRarity rarity) {
    switch (rarity) {
      case ShopRarity.COMMON:
        return Colors.grey;
      case ShopRarity.RARE:
        return Colors.blue;
      case ShopRarity.EPIC:
        return Colors.purple;
      case ShopRarity.LEGENDARY:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showPurchaseDialog(
    BuildContext context,
    String message, {
    bool isSuccess = false,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          isSuccess ? 'Berhasil' : 'Gagal',
          style: AppTextStyles.headingMedium,
        ),
        content: Text(message, style: AppTextStyles.bodyLarge),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (isSuccess) {
                context.pop(); // Go back to shop
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rarityColor = getRarityColor(item.rarity);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'DETAIL ITEM'),
      body: BlocListener<PurchaseCubit, PurchaseState>(
        listener: (context, state) {
          if (state is PurchaseSuccess) {
            context.read<app_auth.AuthBloc>().add(
              app_auth.AuthPointsDeducted(item.price),
            );
            _showPurchaseDialog(
              context,
              'Berhasil membeli ${item.name}!',
              isSuccess: true,
            );
          } else if (state is PurchaseError) {
            _showPurchaseDialog(context, state.message);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFD),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFE8F0FE),
                      width: 2,
                    ),
                  ),
                  child: item.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.network(
                            item.imageUrl!,
                            fit: BoxFit.contain,
                          ),
                        )
                      : const Icon(Icons.image, size: 100, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: AppTextStyles.displayMedium.copyWith(
                              color: AppColors.textNavy,
                              fontWeight: FontWeight.w900,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: rarityColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: rarityColor.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.stars, color: rarityColor, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                item.rarity.name,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: rarityColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.description ?? 'Tidak ada deskripsi',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Harga:',
                            style: AppTextStyles.headingMedium.copyWith(
                              color: Colors.orange.shade800,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.orange,
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${item.price} Poin',
                                style: AppTextStyles.headingLarge.copyWith(
                                  color: Colors.orange.shade800,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<InventoryCubit, InventoryState>(
                      builder: (context, inventoryState) {
                        bool isOwned = false;
                        if (inventoryState is InventoryLoaded) {
                          isOwned = inventoryState.items.any(
                            (invItem) => invItem.shopItemId == item.id,
                          );
                        }

                        return BlocBuilder<PurchaseCubit, PurchaseState>(
                          builder: (context, purchaseState) {
                            final isProcessing = purchaseState is PurchaseLoading;
                            return ElevatedButton(
                              onPressed: isOwned || isProcessing
                                  ? null
                                  : () {
                                      context.read<PurchaseCubit>().buyItem(
                                        item.id,
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isOwned ? Colors.grey : AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: isProcessing
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      isOwned ? 'Telah Dimiliki' : 'Beli Sekarang',
                                      style: AppTextStyles.headingMedium.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
