import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/glass_input.dart';
import '../../../../shared/widgets/glass_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  
  String _loginMethod = 'email'; // 'email' or 'whatsapp'
  String _otpStep = 'request'; // 'request' or 'verify'
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleWhatsAppRequest() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showError('Telefon nömrəsi daxil edilməlidir');
      return;
    }

    setState(() => _isLoading = true);
    final success = await ref.read(authProvider.notifier).requestWhatsAppOTP(phone);
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        setState(() => _otpStep = 'verify');
      }
    }
  }

  Future<void> _handleWhatsAppVerify() async {
    final phone = _phoneController.text.trim();
    final otp = _otpController.text.trim();
    if (otp.length < 6) {
      _showError('6 rəqəmli kodu daxil edin');
      return;
    }

    setState(() => _isLoading = true);
    final sessionLink = await ref.read(authProvider.notifier).verifyWhatsAppOTP(phone, otp);
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (sessionLink != null) {
        final uri = Uri.parse(sessionLink);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          _showInfo('Giriş linki brauzerdə açıldı');
        } else {
          _showError('Link açıla bilmədi');
        }
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9), Color(0xFFF8FAFC)],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Logo
                    Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 80,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Siam Kassam',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Biznesinizi idarə edin. Sadə. Sürətli. Güclü.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    GlassCard(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              _buildTabItem('E-poçt', 'email', Icons.email_outlined),
                              const SizedBox(width: 12),
                              _buildTabItem('WhatsApp', 'whatsapp', Icons.message_outlined),
                            ],
                          ),
                          const SizedBox(height: 32),
                          if (_loginMethod == 'email') 
                            _buildEmailForm(authState) 
                          else 
                            _buildWhatsAppForm(authState),
                          const SizedBox(height: 24),
                          if (authState.error != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                authState.error!,
                                style: const TextStyle(color: AppColors.error, fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Hesabınız yoxdur?',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () => context.go('/register'),
                          child: const Text(
                            'Qeydiyyatdan keçin',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTabItem(String label, String method, IconData icon) {
    final isActive = _loginMethod == method;
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => setState(() => _loginMethod = method),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isActive ? AppColors.primary.withOpacity(0.2) : Colors.transparent),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: isActive ? AppColors.primary : AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm(AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GlassInput(
          labelText: 'E-poçt',
          controller: _emailController,
          prefixIcon: Icons.email_outlined,
          hintText: 'ad@misal.com',
        ),
        const SizedBox(height: 16),
        GlassInput(
          labelText: 'Şifrə',
          controller: _passwordController,
          obscureText: true,
          prefixIcon: Icons.lock_outline,
          hintText: '••••••••',
        ),
        const SizedBox(height: 32),
        GlassButton(
          onPressed: authState.isLoading
              ? () {}
              : () {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  if (email.isEmpty || password.isEmpty) {
                    _showError('Məlumatları doldurun');
                    return;
                  }
                  ref.read(authProvider.notifier).login(email, password);
                },
          child: authState.isLoading
              ? _buildLoadingSpinner()
              : const Text('Daxil Ol →', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildWhatsAppForm(AuthState authState) {
    if (_otpStep == 'request') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'WhatsApp ilə Giriş',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Telefon nömrənizi daxil edin, sizə təsdiq kodu göndərəcəyik.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          GlassInput(
            labelText: 'Telefon Nömrəsi',
            controller: _phoneController,
            prefixIcon: Icons.phone_outlined,
            hintText: '+994 50 000 00 00',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 32),
          GlassButton(
            onPressed: authState.isLoading ? () {} : _handleWhatsAppRequest,
            child: authState.isLoading
                ? _buildLoadingSpinner()
                : const Text('Kod Göndər', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Təsdiq Kodu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            '${_phoneController.text} nömrəsinə göndərilən 6 rəqəmli kodu daxil edin.',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          GlassInput(
            labelText: 'OTP Kod',
            controller: _otpController,
            prefixIcon: Icons.lock_outline,
            hintText: '••••••',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => setState(() => _otpStep = 'request'),
            child: const Text('Nömrəni düzəlt', style: TextStyle(color: AppColors.primary, fontSize: 13)),
          ),
          const SizedBox(height: 20),
          GlassButton(
            onPressed: authState.isLoading ? () {} : _handleWhatsAppVerify,
            child: authState.isLoading
                ? _buildLoadingSpinner()
                : const Text('Təsdiqlə və Daxil Ol', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      );
    }
  }

  Widget _buildLoadingSpinner() {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
    );
  }
}

