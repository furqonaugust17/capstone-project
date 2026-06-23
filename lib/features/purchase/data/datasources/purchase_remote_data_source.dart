import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../../core/network/utils/network_error_handler.dart';
import '../../../../core/network/exceptions/network_exception.dart';
import '../models/purchase_history_model.dart';

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

      final apiResponse = ApiResponse<PurchaseHistoryModel>.fromJson(
        response.data,
        (json) => PurchaseHistoryModel.fromJson(
            (json as Map<String, dynamic>)['purchaseHistory'] as Map<String, dynamic>),
      );

      if (apiResponse.data == null) {
        throw const UnknownNetworkException('Failed to process purchase: Data is null');
      }

      return apiResponse.data!;
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
