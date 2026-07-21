import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  const AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataSource.login(email: email, password: password);
    await _localDataSource.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return response.user.toEntity();
  }

  @override
  Future<UserEntity> register({
    required String username,
    required String email,
    required String password,
    String? displayName,
  }) async {
    final response = await _remoteDataSource.register(
      username: username,
      email: email,
      password: password,
      displayName: displayName,
    );
    return response.toEntity();
  }

  @override
  Future<void> logout() async {
    final refreshToken = await _localDataSource.getRefreshToken();
    if (refreshToken != null) {
      try {
        await _remoteDataSource.logout(refreshToken);
      } catch (_) {
        // Ignore error on logout api call
      }
    }
    await _localDataSource.clearTokens();
  }

  @override
  Future<UserEntity> getProfile() async {
    final response = await _remoteDataSource.getProfile();
    return response.toEntity();
  }

  @override
  Future<void> refreshToken() async {
    final refreshToken = await _localDataSource.getRefreshToken();
    if (refreshToken != null) {
      final newAccessToken = await _remoteDataSource.refreshToken(refreshToken);
      await _localDataSource.saveAccessToken(newAccessToken);
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _localDataSource.hasTokens();
  }

  @override
  Future<String?> getStoredAccessToken() async {
    return await _localDataSource.getAccessToken();
  }
}
