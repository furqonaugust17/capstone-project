import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../../core/network/models/paginated_response.dart';
import '../../../../core/network/utils/network_error_handler.dart';
import '../../../../core/network/exceptions/network_exception.dart';
import '../models/shop_item_model.dart';
import '../../domain/entities/shop_item_entity.dart';

abstract class ShopRemoteDataSource {
  Future<PaginatedResponse<ShopItemModel>> getShopItems({
    int page = 1,
    int limit = 10,
    ShopCategory? category,
    ShopRarity? rarity,
  });

  Future<ShopItemModel> getShopItemDetail(String id);
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  final ApiClient _apiClient;

  ShopRemoteDataSourceImpl(this._apiClient);

  @override
  Future<PaginatedResponse<ShopItemModel>> getShopItems({
    int page = 1,
    int limit = 10,
    ShopCategory? category,
    ShopRarity? rarity,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (category != null) {
        queryParams['category'] = category.name;
      }
      if (rarity != null) {
        queryParams['rarity'] = rarity.name;
      }

      final response = await _apiClient.dio.get('/shop', queryParameters: queryParams);

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.data == null) {
        throw const UnknownNetworkException('Failed to fetch shop items: Data is null');
      }

      return PaginatedResponse<ShopItemModel>.fromJson(
        apiResponse.data!,
        (json) => ShopItemModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      throw UnknownNetworkException(e.toString());
    }
  }

  @override
  Future<ShopItemModel> getShopItemDetail(String id) async {
    try {
      final response = await _apiClient.dio.get('/shop/$id');

      final apiResponse = ApiResponse<ShopItemModel>.fromJson(
        response.data,
        (json) => ShopItemModel.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.data == null) {
        throw const UnknownNetworkException('Failed to fetch shop item detail: Data is null');
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      throw UnknownNetworkException(e.toString());
    }
  }
}
