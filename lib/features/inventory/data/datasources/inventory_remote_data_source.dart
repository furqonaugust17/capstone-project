import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../../core/network/utils/network_error_handler.dart';
import '../../../../core/network/exceptions/network_exception.dart';
import '../models/user_inventory_model.dart';
import '../../../purchase/data/models/purchase_history_model.dart';
import '../../../../core/network/models/paginated_response.dart';

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

      final apiResponse = ApiResponse<PaginatedResponse<UserInventoryModel>>.fromJson(
        response.data,
        (json) => PaginatedResponse<UserInventoryModel>.fromJson(
          json as Map<String, dynamic>,
          (itemJson) => UserInventoryModel.fromJson(itemJson as Map<String, dynamic>),
        ),
      );

      if (apiResponse.data == null) {
        throw const UnknownNetworkException('Failed to fetch inventory: Data is null');
      }

      return apiResponse.data!.data;
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

      final apiResponse = ApiResponse<PaginatedResponse<PurchaseHistoryModel>>.fromJson(
        response.data,
        (json) => PaginatedResponse<PurchaseHistoryModel>.fromJson(
          json as Map<String, dynamic>,
          (itemJson) => PurchaseHistoryModel.fromJson(itemJson as Map<String, dynamic>),
        ),
      );

      if (apiResponse.data == null) {
        throw const UnknownNetworkException('Failed to fetch purchase history: Data is null');
      }

      return apiResponse.data!.data;
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      throw UnknownNetworkException(e.toString());
    }
  }
}
