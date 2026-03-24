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

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return response;
  }

  // WhatsApp OTP methods matching web app
  Future<bool> requestWhatsAppOTP(String phone) async {
    final response = await supabase.functions.invoke(
      'whatsapp-auth-otp',
      body: {'phone': phone, 'action': 'request'},
    );
    
    if (response.status != 200) return false;
    final data = response.data as Map<String, dynamic>;
    return data['success'] == true;
  }

  Future<String?> verifyWhatsAppOTP(String phone, String otp) async {
    final response = await supabase.functions.invoke(
      'whatsapp-auth-otp',
      body: {'phone': phone, 'code': otp, 'action': 'verify'},
    );

    if (response.status != 200) return null;
    final data = response.data as Map<String, dynamic>;
    
    if (data['success'] == true && data['session_link'] != null) {
      // The web app uses session_link for magic link login. 
      // In Flutter, if the function returns a session_link, we might need to handle it 
      // or the function might handle the session creation itself.
      // Based on LoginPage.jsx, it does: window.location.href = data.session_link;
      return data['session_link'] as String;
    }
    return null;
  }
}
