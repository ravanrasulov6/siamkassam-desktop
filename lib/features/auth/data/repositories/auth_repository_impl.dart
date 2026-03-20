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
    final profile = await remoteDataSource.getUserProfile(response.user!.id);
    return _mapToEntity(response.user!, profile: profile);
  }

  @override
  Future<UserEntity> register({required String email, required String password, Map<String, dynamic>? data}) async {
    final response = await remoteDataSource.register(email, password, data: data);
    if (response.user == null) throw Exception('Registration failed');
    final profile = await remoteDataSource.getUserProfile(response.user!.id);
    return _mapToEntity(response.user!, profile: profile);
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
    if (user == null) return null;
    final profile = await remoteDataSource.getUserProfile(user.id);
    return _mapToEntity(user, profile: profile);
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    // Mapping Supabase auth state to our Entity
    return remoteDataSource.supabase.auth.onAuthStateChange.asyncMap((event) async {
      final user = event.session?.user;
      if (user == null) return null;
      final profile = await remoteDataSource.getUserProfile(user.id);
      return _mapToEntity(user, profile: profile);
    });
  }

  UserEntity _mapToEntity(supabase.User user, {Map<String, dynamic>? profile}) {
    return UserEntity(
      id: user.id,
      email: user.email ?? '',
      fullName: profile?['first_name'] != null 
          ? '${profile!['first_name']} ${profile['last_name'] ?? ''}'
          : user.userMetadata?['full_name'],
      businessId: profile?['business_id'] ?? user.userMetadata?['business_id'],
      onboardingCompleted: profile?['onboarding_completed'] ?? user.userMetadata?['onboarding_completed'] ?? false,
    );
  }
}

