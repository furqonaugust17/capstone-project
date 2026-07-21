import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/shop_item_entity.dart';
import '../../domain/usecases/get_shop_items_usecase.dart';
import 'shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  final GetShopItemsUseCase _getShopItemsUseCase;

  int _currentPage = 1;
  final int _limit = 10;
  bool _isFetching = false;

  ShopCubit(this._getShopItemsUseCase) : super(ShopInitial());

  Future<void> fetchItems({
    ShopCategory? category,
    ShopRarity? rarity,
    bool refresh = false,
  }) async {
    if (_isFetching) return;
    
    List<ShopItemEntity> currentItems = [];
    ShopCategory? currentCategory = category;
    ShopRarity? currentRarity = rarity;

    if (state is ShopLoaded && !refresh) {
      final currentState = state as ShopLoaded;
      if (currentState.hasReachedMax) return;
      currentItems = currentState.items;
      currentCategory = category ?? currentState.selectedCategory;
      currentRarity = rarity ?? currentState.selectedRarity;
      emit(ShopLoading(isFirstFetch: false));
    } else {
      _currentPage = 1;
      emit(const ShopLoading(isFirstFetch: true));
    }

    _isFetching = true;

    try {
      final response = await _getShopItemsUseCase(
        page: _currentPage,
        limit: _limit,
        category: currentCategory,
        rarity: currentRarity,
      );

      _currentPage++;
      final newItems = List<ShopItemEntity>.from(currentItems)..addAll(response.data);
      
      emit(ShopLoaded(
        items: newItems,
        hasReachedMax: response.meta.page >= response.meta.totalPages,
        selectedCategory: currentCategory,
        selectedRarity: currentRarity,
      ));
    } catch (e) {
      if (currentItems.isNotEmpty) {
        emit(ShopLoaded(
          items: currentItems,
          hasReachedMax: false,
          selectedCategory: currentCategory,
          selectedRarity: currentRarity,
        ));
      } else {
        emit(ShopError(e.toString()));
      }
    } finally {
      _isFetching = false;
    }
  }

  void updateFilters({ShopCategory? category, ShopRarity? rarity, bool clearCategory = false, bool clearRarity = false}) {
    if (state is ShopLoaded) {
      final currentState = state as ShopLoaded;
      fetchItems(
        category: clearCategory ? null : (category ?? currentState.selectedCategory),
        rarity: clearRarity ? null : (rarity ?? currentState.selectedRarity),
        refresh: true,
      );
    } else {
      fetchItems(category: category, rarity: rarity, refresh: true);
    }
  }
}
