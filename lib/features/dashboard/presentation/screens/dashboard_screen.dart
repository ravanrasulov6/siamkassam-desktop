import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0E7FF), Color(0xFFF1F5F9), Color(0xFFE0E7FF)],
          ),
        ),
        child: Row(
          children: [
            // Sidebar
            _buildSidebar(context, ref),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Xoş gəldiniz, ${user?.fullName ?? 'İstifadəçi'}!',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const Text('Bu günün icmalı buradadır.', style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Stats Grid
                    GridView.count(
                      crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 1.5,
                      children: [
                        _buildAnimatedStatCard(0, 'Müştərilər', '24', Icons.people_outline, AppColors.primary),
                        _buildAnimatedStatCard(1, 'Məhsullar', '156', Icons.inventory_2_outlined, Colors.orange),
                        _buildAnimatedStatCard(2, 'Bugünkü Satış', '450 AZN', Icons.payments_outlined, AppColors.success),
                        _buildAnimatedStatCard(3, 'Borclar', '1,200 AZN', Icons.money_off_outlined, AppColors.error),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    const Text('Son Fəaliyyətlər', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    GlassCard(
                      padding: const EdgeInsets.all(0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) => ListTile(
                          leading: CircleAvatar(backgroundColor: AppColors.glassWhite, child: const Icon(Icons.shopping_cart_outlined, size: 20)),
                          title: const Text('Yeni satış: #1023'),
                          subtitle: const Text('2 dəqiqə əvvəl'),
                          trailing: const Text('45 AZN', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, WidgetRef ref) {
    final String currentLocation = GoRouterState.of(context).matchedLocation;

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        border: Border(right: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 48),
          Image.asset(
            'assets/images/logo.png',
            height: 60,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.business_center, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          const Text(
            'Siam Kassam',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 32),
          _buildSidebarItem(Icons.dashboard_outlined, 'Panel', currentLocation == '/', () => context.go('/')),
          _buildSidebarItem(Icons.shopping_cart_outlined, 'POS', currentLocation == '/pos', () => context.go('/pos')),
          _buildSidebarItem(Icons.list_alt_rounded, 'Satışlar', currentLocation == '/sales', () => context.go('/sales')),
          _buildSidebarItem(Icons.inventory_2_outlined, 'Məhsullar', currentLocation == '/products', () => context.go('/products')),
          _buildSidebarItem(Icons.people_alt_outlined, 'Müştərilər', currentLocation == '/customers', () => context.go('/customers')),
          _buildSidebarItem(Icons.credit_card_outlined, 'Borclar', currentLocation == '/debts', () => context.go('/debts')),
          _buildSidebarItem(Icons.payments_outlined, 'Xərclər', currentLocation == '/expenses', () => context.go('/expenses')),
          _buildSidebarItem(Icons.bar_chart_outlined, 'Hesabatlar', currentLocation == '/reports', () => context.go('/reports')),
          _buildSidebarItem(Icons.psychology_outlined, 'AI Mərkəzi', currentLocation == '/ai', () => context.go('/ai')),
          _buildSidebarItem(Icons.mail_outline_rounded, 'Məktublarım', currentLocation == '/messages', () => context.go('/messages')),
          _buildSidebarItem(Icons.settings_outlined, 'Tənzimləmələr', currentLocation == '/settings', () => context.go('/settings')),

          const Spacer(),
          _buildSidebarItem(Icons.logout, 'Çıxış', false, () {
            ref.read(authProvider.notifier).logout();
          }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: isActive ? AppColors.primary : AppColors.textSecondary),
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      selected: isActive,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
    );
  }

  Widget _buildAnimatedStatCard(int index, String title, String value, IconData icon, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: _buildStatCard(title, value, icon, color),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: StatefulBuilder(
        builder: (context, setState) {
          bool isHovered = false;
          return MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: isHovered 
                ? (Matrix4.identity()..translate(0, -4, 0)..scale(1.02))
                : Matrix4.identity(),
              child: GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: color, size: 32),
                    const SizedBox(height: 16),
                    Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
