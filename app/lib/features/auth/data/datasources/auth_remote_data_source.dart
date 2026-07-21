import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../../core/network/utils/network_error_handler.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    String? displayName,
  });

  Future<String> refreshToken(String refreshToken);

  Future<UserModel> getProfile();

  Future<void> logout(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  const AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.authLoginPath,
        data: {
          'email': email,
          'password': password,
        },
      );
      final apiResponse = ApiResponse<LoginResponseModel>.fromJson(
        response.data,
        (json) => LoginResponseModel.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.data!;
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  @override
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.authRegisterPath,
        data: {
          'username': username,
          'email': email,
          'password': password,
          if (displayName != null) 'displayName': displayName,
        },
      );
      final apiResponse = ApiResponse<UserModel>.fromJson(
        response.data,
        (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.data!;
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.authRefreshPath,
        data: {
          'refreshToken': refreshToken,
        },
      );
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
      return apiResponse.data!['accessToken'] as String;
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.dio.get(AppConstants.authMePath);
      final apiResponse = ApiResponse<UserModel>.fromJson(
        response.data,
        (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.data!;
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await _apiClient.dio.post(
        AppConstants.authLogoutPath,
        data: {
          'refreshToken': refreshToken,
        },
      );
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }
}
