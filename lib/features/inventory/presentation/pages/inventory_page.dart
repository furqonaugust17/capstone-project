import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/shared/widgets/custom_app_bar.dart';
import 'package:app/features/inventory/presentation/bloc/inventory_cubit.dart';
import 'package:app/features/inventory/presentation/bloc/inventory_state.dart';
import 'package:app/injection/injection.dart';
import 'package:app/features/inventory/domain/entities/user_inventory_entity.dart';
import 'package:app/features/purchase/domain/entities/purchase_history_entity.dart';
import 'package:app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:app/features/auth/presentation/bloc/auth_state.dart';
import 'package:app/features/auth/presentation/bloc/auth_event.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<InventoryCubit>()..fetchInventory(),
      child: const InventoryView(),
    );
  }
}

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      if (_tabController.index == 0) {
        context.read<InventoryCubit>().fetchInventory();
      } else {
        context.read<InventoryCubit>().fetchPurchaseHistory();
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'INVENTARIS'),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3FA),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.primary,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Item Saya'),
                  Tab(text: 'Riwayat Pembelian'),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocListener<InventoryCubit, InventoryState>(
              listener: (context, state) {
                if (state is EquipSuccess) {
                  _showPopup(context, 'Sukses', 'Item berhasil digunakan!');
                  context.read<AuthBloc>().add(AuthCheckRequested());
                } else if (state is UnequipSuccess) {
                  _showPopup(context, 'Sukses', 'Item berhasil dilepas!');
                  context.read<AuthBloc>().add(AuthCheckRequested());
                } else if (state is InventoryError) {
                  _showPopup(context, 'Gagal', state.message, isError: true);
                }
              },
              child: BlocBuilder<InventoryCubit, InventoryState>(
                builder: (context, state) {
                  if (state is InventoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is InventoryError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (_tabController.index == 0) {
                                context.read<InventoryCubit>().fetchInventory();
                              } else {
                                context
                                    .read<InventoryCubit>()
                                    .fetchPurchaseHistory();
                              }
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is InventoryLoaded &&
                      _tabController.index == 0) {
                    final items = state.items;
                    if (items.isEmpty) {
                      return _buildEmptyState(
                        'Kamu belum memiliki item apapun.',
                      );
                    }
                    return _buildInventoryGrid(items);
                  } else if (state is PurchaseHistoryLoaded &&
                      _tabController.index == 1) {
                    final history = state.history;
                    if (history.isEmpty) {
                      return _buildEmptyState(
                        'Kamu belum pernah membeli item.',
                      );
                    }
                    return _buildHistoryList(history);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPopup(
    BuildContext context,
    String title,
    String message, {
    bool isError = false,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(
              color: isError ? AppColors.error : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(message, style: AppTextStyles.bodyMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryGrid(List<UserInventoryEntity> items) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState is Authenticated ? authState.user : null;

        return RefreshIndicator(
          onRefresh: () async {
            context.read<InventoryCubit>().fetchInventory();
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.72,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              bool isEquipped = false;

              if (user != null && item.itemImageUrl != null) {
                if (item.category.toLowerCase() == 'avatar') {
                  isEquipped = user.equippedAvatarUrl == item.itemImageUrl;
                } else if (item.category.toLowerCase() == 'frame') {
                  isEquipped = user.equippedFrameUrl == item.itemImageUrl;
                } else if (item.category.toLowerCase() == 'theme') {
                  isEquipped = user.equippedThemeUrl == item.itemImageUrl;
                }
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isEquipped
                        ? AppColors.primary
                        : const Color(0xFFE8F0FE),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isEquipped
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : const Color(0xFFF8FAFD),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14),
                          ),
                        ),
                        child: item.itemImageUrl != null
                            ? ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(14),
                                ),
                                child: Image.network(
                                  item.itemImageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.itemName,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textNavy,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item.category,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 32,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (isEquipped) {
                                    context.read<InventoryCubit>().unequipItem(item.category.toLowerCase());
                                  } else {
                                    context.read<InventoryCubit>().equipItem(item.shopItemId, item.category.toLowerCase());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isEquipped
                                      ? Colors.grey.shade300
                                      : AppColors.primary,
                                  foregroundColor: isEquipped
                                      ? Colors.black87
                                      : Colors.white,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  isEquipped ? 'Dilepas' : 'Gunakan',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHistoryList(List<PurchaseHistoryEntity> history) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<InventoryCubit>().fetchPurchaseHistory();
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: history.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final purchase = history[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8F0FE), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: purchase.shopItem?.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            purchase.shopItem!.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.shopping_bag,
                          color: Colors.orange,
                          size: 30,
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        purchase.shopItem?.name ?? 'Item tidak diketahui',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textNavy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat(
                          'dd MMMM yyyy, HH:mm',
                        ).format(purchase.purchasedAt.toLocal()),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '-${purchase.priceAtPurchase}',
                      style: AppTextStyles.headingMedium.copyWith(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.orange,
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Poin',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
