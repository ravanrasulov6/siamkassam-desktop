import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/glass_input.dart';
import '../../../../shared/widgets/glass_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0E7FF), Color(0xFFF1F5F9), Color(0xFFE0E7FF)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24),
              child: GlassCard(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Siam Kassam',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Hoş gəlmisiniz! Zəhmət olmasa daxil olun.',
                      style: TextStyle(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    GlassInput(
                      labelText: 'E-poçt',
                      controller: _emailController,
                      prefixIcon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),
                    GlassInput(
                      labelText: 'Şifrə',
                      controller: _passwordController,
                      obscureText: true,
                      prefixIcon: Icons.lock_outline,
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
                              ref.read(authProvider.notifier).login(
                                    _emailController.text,
                                    _passwordController.text,
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
                          : const Text('Daxil Ol'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // Navigate to register
                      },
                      child: const Text(
                        'Hesabınız yoxdur? Qeydiyyatdan keçin',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
