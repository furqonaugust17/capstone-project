import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../../core/network/utils/network_error_handler.dart';
import '../../../../core/network/exceptions/network_exception.dart';
import '../models/user_inventory_model.dart';
import '../../../purchase/data/models/purchase_history_model.dart';

abstract class InventoryRemoteDataSource {
  Future<List<UserInventoryModel>> getMyInventory();
  Future<List<PurchaseHistoryModel>> getPurchaseHistory();
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final ApiClient _apiClient;

  InventoryRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<UserInventoryModel>> getMyInventory() async {
    try {
      final response = await _apiClient.dio.get('/inventory');

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );

      if (apiResponse.data == null) {
        throw const UnknownNetworkException('Failed to fetch inventory: Data is null');
      }

      return apiResponse.data!
          .map((json) => UserInventoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      throw UnknownNetworkException(e.toString());
    }
  }

  @override
  Future<List<PurchaseHistoryModel>> getPurchaseHistory() async {
    try {
      final response = await _apiClient.dio.get('/inventory/history');

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );

      if (apiResponse.data == null) {
        throw const UnknownNetworkException('Failed to fetch purchase history: Data is null');
      }

      return apiResponse.data!
          .map((json) => PurchaseHistoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      throw UnknownNetworkException(e.toString());
    }
  }
}
