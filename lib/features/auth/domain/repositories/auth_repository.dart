import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity> register({required String email, required String password, Map<String, dynamic>? data});
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
  Future<void> updateProfile(Map<String, dynamic> updates);
  Stream<UserEntity?> authStateChanges();
}

