import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../../core/network/utils/network_error_handler.dart';
import '../../../../core/network/exceptions/network_exception.dart';
import '../models/user_statistic_model.dart';

abstract class StatisticsRemoteDataSource {
  Future<UserStatisticModel> getMyStatistics();
}

class StatisticsRemoteDataSourceImpl implements StatisticsRemoteDataSource {
  final ApiClient _apiClient;

  StatisticsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserStatisticModel> getMyStatistics() async {
    try {
      final response = await _apiClient.dio.get('/statistics/my');

      final apiResponse = ApiResponse<UserStatisticModel>.fromJson(
        response.data,
        (json) => UserStatisticModel.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.data == null) {
        throw const UnknownNetworkException('Failed to fetch statistics: Data is null');
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      throw UnknownNetworkException(e.toString());
    }
  }
}
