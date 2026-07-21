import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../../core/network/utils/network_error_handler.dart';
import '../../../../core/network/exceptions/network_exception.dart';
import '../models/purchase_history_model.dart';
import '../../../../features/shop/data/models/shop_item_model.dart';

abstract class PurchaseRemoteDataSource {
  Future<PurchaseHistoryModel> buyItem(String itemId);
}

class PurchaseRemoteDataSourceImpl implements PurchaseRemoteDataSource {
  final ApiClient _apiClient;

  PurchaseRemoteDataSourceImpl(this._apiClient);

  @override
  Future<PurchaseHistoryModel> buyItem(String itemId) async {
    try {
      final response = await _apiClient.dio.post('/purchase/$itemId');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.data == null) {
        throw const UnknownNetworkException('Failed to process purchase: Data is null');
      }

      final itemJson = apiResponse.data!['item'] as Map<String, dynamic>;
      final shopItem = ShopItemModel.fromJson(itemJson);

      return PurchaseHistoryModel(
        id: 'dummy',
        userId: 'dummy',
        shopItemId: shopItem.id,
        priceAtPurchase: shopItem.price,
        purchasedAt: DateTime.now(),
        shopItem: shopItem,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw UnknownNetworkException(
            e.response?.data['message'] ?? 'Poin tidak cukup',
            statusCode: 400);
      }
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      throw UnknownNetworkException(e.toString());
    }
  }
}
