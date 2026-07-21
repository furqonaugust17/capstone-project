import 'package:app/core/network/models/paginated_response.dart';
import 'package:app/core/network/utils/network_error_handler.dart';
import 'package:dio/dio.dart';

import 'package:app/core/network/exceptions/network_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/models/api_response.dart';
import '../models/game_session_model.dart';
import '../models/submit_game_request.dart';

abstract class GameSessionRemoteDataSource {
  Future<GameSessionModel> submitGameResult(SubmitGameRequest request);
  Future<PaginatedResponse<GameSessionModel>> getHistory({
    int page = 1,
    int limit = 10,
  });
  Future<GameSessionModel> getSessionDetail(String id);
}

class GameSessionRemoteDataSourceImpl implements GameSessionRemoteDataSource {
  final ApiClient _apiClient;

  GameSessionRemoteDataSourceImpl(this._apiClient);

  @override
  Future<GameSessionModel> submitGameResult(SubmitGameRequest request) async {
    try {
      final formData = FormData.fromMap(request.toJson());

      if (request.fileBytes != null) {
        formData.files.add(
          MapEntry(
            'file',
            MultipartFile.fromBytes(
              request.fileBytes!,
              filename: 'drawing_${DateTime.now().millisecondsSinceEpoch}.png',
            ),
          ),
        );
      }

      final response = await _apiClient.dio.post(
        '/game-sessions',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final apiResponse = ApiResponse<GameSessionModel>.fromJson(
        response.data,
        (json) => GameSessionModel.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.data == null) {
        throw const UnknownNetworkException(
          'Failed to submit game result: Data is null',
        );
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      throw UnknownNetworkException(e.toString());
    }
  }

  @override
  Future<PaginatedResponse<GameSessionModel>> getHistory({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/game-sessions',
        queryParameters: {'page': page, 'limit': limit},
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.data == null) {
        throw const UnknownNetworkException(
          'Failed to fetch history: Data is null',
        );
      }

      return PaginatedResponse<GameSessionModel>.fromJson(
        apiResponse.data!,
        (json) => GameSessionModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      throw UnknownNetworkException(e.toString());
    }
  }

  @override
  Future<GameSessionModel> getSessionDetail(String id) async {
    try {
      final response = await _apiClient.dio.get('/game-sessions/$id');

      final apiResponse = ApiResponse<GameSessionModel>.fromJson(
        response.data,
        (json) => GameSessionModel.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.data == null) {
        throw const UnknownNetworkException(
          'Failed to fetch session detail: Data is null',
        );
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      throw UnknownNetworkException(e.toString());
    }
  }
}
