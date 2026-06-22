import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../../core/network/utils/network_error_handler.dart';
import '../../../../core/network/models/paginated_response.dart';
import '../models/animal_model.dart';

abstract class AnimalRemoteDataSource {
  Future<List<AnimalModel>> getAnimals();
}

class AnimalRemoteDataSourceImpl implements AnimalRemoteDataSource {
  final ApiClient _apiClient;

  const AnimalRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<AnimalModel>> getAnimals() async {
    try {
      // By default the query is ?limit=100 so we get everything in one page for now.
      final response = await _apiClient.dio.get(
        AppConstants.animalsPath,
        queryParameters: {'limit': 100},
      );
      
      final apiResponse = ApiResponse<PaginatedResponse<AnimalModel>>.fromJson(
        response.data,
        (json) => PaginatedResponse<AnimalModel>.fromJson(
          json as Map<String, dynamic>,
          (itemJson) => AnimalModel.fromJson(itemJson as Map<String, dynamic>),
        ),
      );
      
      return apiResponse.data?.data ?? [];
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }
}
