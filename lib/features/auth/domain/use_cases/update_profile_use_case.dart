import '../repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call(Map<String, dynamic> updates) async {
    await repository.updateProfile(updates);
  }
}
