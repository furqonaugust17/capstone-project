import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../../core/network/utils/network_error_handler.dart';
import '../../../../core/network/exceptions/network_exception.dart';
import '../models/leaderboard_entry_model.dart';
import '../models/my_rank_model.dart';
import '../models/leaderboard_snapshot_model.dart';

abstract class LeaderboardRemoteDataSource {
  Future<List<LeaderboardEntryModel>> getLiveLeaderboard({int limit = 100});
  Future<MyRankModel> getMyRank();
  Future<LeaderboardSnapshotModel> getLeaderboardSnapshot({
    required String period,
    required String periodLabel,
  });
}

class LeaderboardRemoteDataSourceImpl implements LeaderboardRemoteDataSource {
  final ApiClient _apiClient;

  LeaderboardRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<LeaderboardEntryModel>> getLiveLeaderboard({int limit = 100}) async {
    try {
      final response = await _apiClient.dio.get(
        '/leaderboards/live',
        queryParameters: {'limit': limit},
      );

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );

      if (apiResponse.data == null) {
        throw const UnknownNetworkException('Failed to fetch live leaderboard: Data is null');
      }

      return apiResponse.data!
          .map((json) => LeaderboardEntryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      throw UnknownNetworkException(e.toString());
    }
  }

  @override
  Future<MyRankModel> getMyRank() async {
    try {
      final response = await _apiClient.dio.get('/leaderboards/me');

      final apiResponse = ApiResponse<MyRankModel>.fromJson(
        response.data,
        (json) => MyRankModel.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.data == null) {
        throw const UnknownNetworkException('Failed to fetch my rank: Data is null');
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      throw UnknownNetworkException(e.toString());
    }
  }

  @override
  Future<LeaderboardSnapshotModel> getLeaderboardSnapshot({
    required String period,
    required String periodLabel,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/leaderboards/snapshot',
        queryParameters: {
          'period': period,
          'periodLabel': periodLabel,
        },
      );

      final apiResponse = ApiResponse<LeaderboardSnapshotModel>.fromJson(
        response.data,
        (json) => LeaderboardSnapshotModel.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.data == null) {
        throw const UnknownNetworkException('Failed to fetch leaderboard snapshot: Data is null');
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      throw UnknownNetworkException(e.toString());
    }
  }
}
