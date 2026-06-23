import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/shared/widgets/custom_app_bar.dart';
import 'package:app/features/shop/presentation/bloc/shop_cubit.dart';
import 'package:app/features/shop/presentation/bloc/shop_state.dart';
import 'package:app/features/shop/domain/entities/shop_item_entity.dart';
import 'package:app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:app/features/auth/presentation/bloc/auth_state.dart';
import 'package:app/injection/injection.dart';
import 'package:go_router/go_router.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<ShopCubit>()..fetchItems(),
      child: const ShopView(),
    );
  }
}

class ShopView extends StatefulWidget {
  const ShopView({super.key});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<ShopCubit>().fetchItems();
    }
  }

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

  Widget _buildCategoryTabs(ShopCategory? selectedCategory) {
    final categories = [null, ...ShopCategory.values];
    final labels = ['Semua', 'Avatar', 'Frame', 'Sticker', 'Theme'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(categories.length, (index) {
          final cat = categories[index];
          final isSelected = selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                labels[index],
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: const Color(0xFFF3F3FA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: isSelected ? AppColors.primary : Colors.transparent),
              ),
              onSelected: (selected) {
                if (selected) {
                  context.read<ShopCubit>().updateFilters(
                        category: cat,
                        clearCategory: cat == null,
                      );
                }
              },
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'TOKO ITEM',
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              int points = 0;
              if (state is Authenticated) {
                points = state.user.totalPoint;
              }
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.orange, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '$points Poin',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ShopCubit, ShopState>(
        builder: (context, state) {
          List<ShopItemEntity> items = [];
          ShopCategory? category;
          bool isLoading = false;
          bool hasError = false;
          String errorMessage = '';

          if (state is ShopLoading) {
            isLoading = state.isFirstFetch;
          } else if (state is ShopLoaded) {
            items = state.items;
            category = state.selectedCategory;
          } else if (state is ShopError) {
            hasError = true;
            errorMessage = state.message;
          }

          return Column(
            children: [
              const SizedBox(height: 16),
              _buildCategoryTabs(category),
              const SizedBox(height: 16),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : hasError
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  errorMessage,
                                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<ShopCubit>().fetchItems(refresh: true);
                                  },
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          )
                        : items.isEmpty
                            ? const Center(child: Text('Tidak ada item yang ditemukan.'))
                            : RefreshIndicator(
                                onRefresh: () async {
                                  context.read<ShopCubit>().fetchItems(refresh: true);
                                },
                                child: GridView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    childAspectRatio: 0.75,
                                  ),
                                  itemCount: state is ShopLoaded && !state.hasReachedMax
                                      ? items.length + 2
                                      : items.length,
                                  itemBuilder: (context, index) {
                                    if (index >= items.length) {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                    final item = items[index];
                                    return _ShopItemCard(
                                      item: item,
                                      rarityColor: getRarityColor(item.rarity),
                                      onTap: () {
                                        context.push('/shop/${item.id}', extra: item);
                                      },
                                    );
                                  },
                                ),
                              ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  final ShopItemEntity item;
  final Color rarityColor;
  final VoidCallback onTap;

  const _ShopItemCard({
    required this.item,
    required this.rarityColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8F0FE), width: 2),
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
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFD),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: item.imageUrl != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                        child: Image.network(item.imageUrl!, fit: BoxFit.cover),
                      )
                    : const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textNavy,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
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
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${item.price} Poin',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
