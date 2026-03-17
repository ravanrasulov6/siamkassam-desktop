import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call(String email, String password, {Map<String, dynamic>? data}) async {
    return await repository.register(email: email, password: password, data: data);
  }
}
