import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/glass_input.dart';
import '../../../../shared/widgets/glass_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                        height: 60,
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
                      'Biznesinizi böyütmək üçün ilk addımı atın.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    GlassCard(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Qeydiyyat',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Başlamaq üçün aşağıdakı xanaları doldurun',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                          const SizedBox(height: 24),
                          GlassInput(
                            labelText: 'Tam Ad',
                            controller: _nameController,
                            prefixIcon: Icons.person_outline,
                            hintText: 'Ad və Soyad',
                          ),
                          const SizedBox(height: 16),
                          GlassInput(
                            labelText: 'E-poçt',
                            controller: _emailController,
                            prefixIcon: Icons.email_outlined,
                            hintText: 'nümunə@siam.az',
                          ),
                          const SizedBox(height: 16),
                          GlassInput(
                            labelText: 'Şifrə',
                            controller: _passwordController,
                            obscureText: true,
                            prefixIcon: Icons.lock_outline,
                            hintText: '••••••••',
                          ),
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
                          GlassButton(
                            onPressed: authState.isLoading
                                ? () {}
                                : () {
                                    final email = _emailController.text.trim();
                                    final password = _passwordController.text.trim();
                                    final name = _nameController.text.trim();
                                    
                                    if (email.isEmpty || password.isEmpty || name.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Zəhmət olmasa bütün xanaları doldurun')),
                                      );
                                      return;
                                    }
                                    
                                    ref.read(authProvider.notifier).register(
                                          email,
                                          password,
                                          fullName: name,
                                        );
                                  },
                            child: authState.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Qeydiyyatı Tamamla →', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Artıq hesabınız var?',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                              ),
                              TextButton(
                                onPressed: () => context.go('/login'),
                                child: const Text(
                                  'Daxil olun',
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
