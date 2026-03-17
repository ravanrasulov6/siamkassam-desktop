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
  final _storeNameController = TextEditingController();
  final _employeeCountController = TextEditingController(text: '1');
  String? _selectedCategory;
  String _selectedSize = 'small';

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
        'biz_name': _storeNameController.text.trim(),
        'biz_category': _selectedCategory,
        'biz_size': _selectedSize,
        'biz_employee_count': int.tryParse(_employeeCountController.text) ?? 1,
        'onboarding_completed': true,
      });
      _nextStep(); // Move to success step
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xəta baş verdi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentStep > 1 && _currentStep < 5) _buildProgressBar(),
                const SizedBox(height: 24),
                GlassCard(
                  padding: const EdgeInsets.all(32),
                  child: _buildStepContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: List.generate(3, (index) {
        final stepNum = index + 2;
        final isActive = stepNum <= _currentStep;
        return Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
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
        return _buildStoreInfoStep();
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
        const Icon(Icons.business_center_outlined, size: 64, color: AppColors.primary),
        const SizedBox(height: 24),
        const Text(
          'Siam Kassam',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        const SizedBox(height: 16),
        const Text(
          'Biznesinizi idarə edin. Sadə. Sürətli. Güclü.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        GlassButton(
          onPressed: _nextStep,
          child: const Text('Başla →', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Şəxsi Məlumatlar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Sizi daha yaxşı tanıyaq', style: TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 24),
        GlassInput(labelText: 'Ad', controller: _firstNameController),
        const SizedBox(height: 16),
        GlassInput(labelText: 'Soyad', controller: _lastNameController),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: _prevStep, child: const Text('Geri')),
            GlassButton(onPressed: _nextStep, child: const Text('Davam et →')),
          ],
        ),
      ],
    );
  }

  Widget _buildStoreInfoStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Mağaza Haqqında', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        GlassInput(labelText: 'Mağaza adı', controller: _storeNameController),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: const Text('Kateqoriya seçin'),
              value: _selectedCategory,
              isExpanded: true,
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: _prevStep, child: const Text('Geri')),
            GlassButton(onPressed: _nextStep, child: const Text('Davam et →')),
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
        const Text('Biznes Həcmi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        GlassInput(labelText: 'İşçi sayı', controller: _employeeCountController, keyboardType: TextInputType.number),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: _prevStep, child: const Text('Geri')),
            GlassButton(
              onPressed: authState.isLoading ? () {} : _completeOnboarding,
              child: authState.isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Tamamla ✓'),
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
        const Icon(Icons.check_circle_outline, size: 80, color: AppColors.success),
        const SizedBox(height: 24),
        const Text('Hazırsınız! 🎉', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const Text('Biznesiniz uğurla qeydiyyatdan keçdi', textAlign: TextAlign.center),
        const SizedBox(height: 32),
        GlassButton(
          onPressed: () => context.go('/'),
          child: const Text('Dashboard-a keç →'),
        ),
      ],
    );
  }
}
