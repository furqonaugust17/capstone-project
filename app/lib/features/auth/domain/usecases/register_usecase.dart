import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);

  Future<UserEntity> call({
    required String username,
    required String email,
    required String password,
    String? displayName,
  }) {
    return _repository.register(
      username: username,
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}
