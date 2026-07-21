import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository _repository;
  const GetProfileUseCase(this._repository);

  Future<UserEntity> call() {
    return _repository.getProfile();
  }
}
