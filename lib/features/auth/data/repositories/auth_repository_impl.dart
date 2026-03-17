import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    final response = await remoteDataSource.login(email, password);
    if (response.user == null) throw Exception('Login failed');
    return _mapToEntity(response.user!);
  }

  @override
  Future<UserEntity> register({required String email, required String password, Map<String, dynamic>? data}) async {
    final response = await remoteDataSource.register(email, password, data: data);
    if (response.user == null) throw Exception('Registration failed');
    return _mapToEntity(response.user!);
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    final userId = remoteDataSource.getCurrentUser()?.id;
    if (userId == null) throw Exception('User not logged in');
    
    await remoteDataSource.supabase
        .from('profiles')
        .update(updates)
        .eq('id', userId);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {

    final user = remoteDataSource.getCurrentUser();
    return user != null ? _mapToEntity(user) : null;
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    // Mapping Supabase auth state to our Entity
    return remoteDataSource.supabase.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      return user != null ? _mapToEntity(user) : null;
    });
  }

  UserEntity _mapToEntity(supabase.User user) {
    return UserEntity(
      id: user.id,
      email: user.email ?? '',
      fullName: user.userMetadata?['full_name'],
      businessId: user.userMetadata?['business_id'],
      onboardingCompleted: user.userMetadata?['onboarding_completed'] ?? false,
    );
  }
}

