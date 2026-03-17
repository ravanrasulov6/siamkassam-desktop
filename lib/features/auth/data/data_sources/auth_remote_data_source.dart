import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  final SupabaseClient supabase;

  AuthRemoteDataSource(this.supabase);

  Future<AuthResponse> login(String email, String password) async {
    return await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> register(String email, String password, {Map<String, dynamic>? data}) async {
    return await supabase.auth.signUp(email: email, password: password, data: data);
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }
}
