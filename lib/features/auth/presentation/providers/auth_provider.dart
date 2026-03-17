import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/supabase_provider.dart';
import '../../data/data_sources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/register_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';
import '../../domain/use_cases/update_profile_use_case.dart';

// Repositories & DataSources Providers
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(supabaseClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

// UseCases Providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.watch(authRepositoryProvider));
});

// State Notifier Provider
class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({UserEntity? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final AuthRepository _repository;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required AuthRepository repository,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _repository = repository,
        super(AuthState(isLoading: true)) {
    _init();
  }

  void _init() async {
    final user = await _repository.getCurrentUser();
    state = state.copyWith(user: user, isLoading: false);
    
    _repository.authStateChanges().listen((user) {
      if (mounted) {
        state = state.copyWith(user: user);
      }
    });
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _loginUseCase(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register(String email, String password, {String? fullName}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _registerUseCase(email, password, data: {'full_name': fullName});
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _updateProfileUseCase(updates);
      final user = await _repository.getCurrentUser();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _logoutUseCase();
    state = state.copyWith(user: null, isLoading: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.watch(loginUseCaseProvider),
    registerUseCase: ref.watch(registerUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    updateProfileUseCase: ref.watch(updateProfileUseCaseProvider),
    repository: ref.watch(authRepositoryProvider),
  );
});

