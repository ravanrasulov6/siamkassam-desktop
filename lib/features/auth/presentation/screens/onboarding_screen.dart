import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/glass_input.dart';
import '../../../../shared/widgets/glass_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 1;
  final int _totalSteps = 5;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bizNameController = TextEditingController();
  final _employeeCountController = TextEditingController(text: '1');
  String? _selectedCategory;

  final List<String> _categories = [
    'Telefon mağazası',
    'Market',
    'Geyim',
    'Elektronika',
    'Əczaxana',
    'Restoran',
    'Kafe',
    'Digər',
  ];

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _completeOnboarding() async {
    try {
      await ref.read(authProvider.notifier).updateProfile({
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'biz_name': _bizNameController.text.trim(),
        'biz_category': _selectedCategory,
        'biz_employee_count': int.tryParse(_employeeCountController.text) ?? 1,
        'onboarding_completed': true,
        'updated_at': DateTime.now().toIso8601String(),
      });
      if (!mounted) return;
      _nextStep(); // Move to success step
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xəta baş verdi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_currentStep > 1 && _currentStep < 5) ...[
                    _buildProgressBar(),
                    const SizedBox(height: 32),
                  ],
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 60,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GlassCard(
                    padding: const EdgeInsets.all(40),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _buildStepContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: List.generate(3, (index) {
        final stepNum = index + 2;
        final isActive = stepNum <= _currentStep;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.textTertiary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3),
              boxShadow: isActive ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ] : null,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildWelcomeStep();
      case 2:
        return _buildPersonalInfoStep();
      case 3:
        return _buildBusinessInfoStep();
      case 4:
        return _buildScaleStep();
      case 5:
        return _buildSuccessStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildWelcomeStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Siam Kassam-a Xoş Gəlmisiniz',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Biznesinizi rəqəmsallaşdırmaq üçün bir neçə addım qalıb. Başlayaq?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 40),
        GlassButton(
          onPressed: _nextStep,
          child: const Text('Bəli, Başlayaq! →', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Şəxsi Məlumatlar',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sizi necə çağıraq?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 32),
        GlassInput(
          labelText: 'Adınız',
          controller: _firstNameController,
          prefixIcon: Icons.person_outline,
          hintText: 'Məs: Əli',
        ),
        const SizedBox(height: 16),
        GlassInput(
          labelText: 'Soyadınız',
          controller: _lastNameController,
          prefixIcon: Icons.person_outline,
          hintText: 'Məs: Məmmədov',
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _prevStep,
                child: const Text('Geri', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: GlassButton(
                onPressed: () {
                  if (_firstNameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Zəhmət olmasa adınızı daxil edin')),
                    );
                    return;
                  }
                  _nextStep();
                },
                child: const Text('Daxil Et →'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBusinessInfoStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Biznes Məlumatları',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        const Text(
          'Şirkətinizin və ya mağazanızın adı nədir?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 32),
        GlassInput(
          labelText: 'Biznes Adı',
          controller: _bizNameController,
          prefixIcon: Icons.business_outlined,
          hintText: 'Məs: Siam Electronics',
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: const Text('Kateqoriya seçin'),
              value: _selectedCategory,
              isExpanded: true,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _prevStep,
                child: const Text('Geri', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: GlassButton(
                onPressed: () {
                  if (_bizNameController.text.trim().isEmpty || _selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Zəhmət olmasa bütün sahələri doldurun')),
                    );
                    return;
                  }
                  _nextStep();
                },
                child: const Text('Davam Et →'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScaleStep() {
    final authState = ref.watch(authProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Biznes Həcmi',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        const Text(
          'Şirkətinizdə təxminən neçə nəfər çalışır?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 32),
        GlassInput(
          labelText: 'İşçi sayı',
          controller: _employeeCountController,
          prefixIcon: Icons.people_outline,
          keyboardType: TextInputType.number,
          hintText: 'Məs: 5',
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _prevStep,
                child: const Text('Geri', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: GlassButton(
                onPressed: authState.isLoading ? null : _completeOnboarding,
                child: authState.isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Quraşdırmanı Bitir ✓'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccessStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.stars_rounded, size: 80, color: AppColors.primary),
        const SizedBox(height: 32),
        const Text(
          'Hər Şey Hazırdır! 🎉',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        const Text(
          'Siam Kassam ailəsinə xoş gəldiniz. İndi biznesinizi idarə etməyə başlaya bilərsiniz.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 48),
        GlassButton(
          onPressed: () => context.go('/'),
          child: const Text('İş masasına keç →', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
