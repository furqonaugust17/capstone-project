import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity> register({
    required String username,
    required String email,
    required String password,
    String? displayName,
  });
  Future<void> logout();
  Future<UserEntity> getProfile();
  Future<void> refreshToken();
  Future<bool> isLoggedIn();
  Future<String?> getStoredAccessToken();
}
