import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../../core/network/utils/network_error_handler.dart';
import '../models/ml_model_model.dart';

abstract class MLModelRemoteDataSource {
  Future<MLModelModel> getActiveModel();
}

class MLModelRemoteDataSourceImpl implements MLModelRemoteDataSource {
  final ApiClient _apiClient;

  const MLModelRemoteDataSourceImpl(this._apiClient);

  @override
  Future<MLModelModel> getActiveModel() async {
    try {
      final response = await _apiClient.dio.get(
        AppConstants.mlModelsActivePath,
      );
      final apiResponse = ApiResponse<MLModelModel>.fromJson(
        response.data,
        (json) => MLModelModel.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.data == null) {
        throw Exception('No active ML model found');
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }
}
