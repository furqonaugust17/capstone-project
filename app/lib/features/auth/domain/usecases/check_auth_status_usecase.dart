import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository _repository;
  const CheckAuthStatusUseCase(this._repository);

  /// Returns UserEntity if valid session exists, null otherwise.
  Future<UserEntity?> call() async {
    final isLoggedIn = await _repository.isLoggedIn();
    if (!isLoggedIn) return null;
    try {
      return await _repository.getProfile();
    } catch (_) {
      return null; // token invalid or network error
    }
  }
}
