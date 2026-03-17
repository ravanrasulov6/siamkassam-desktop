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
                        _buildStatCard('Müştərilər', '24', Icons.people_outline, AppColors.primary),
                        _buildStatCard('Məhsullar', '156', Icons.inventory_2_outlined, Colors.orange),
                        _buildStatCard('Bugünkü Satış', '450 AZN', Icons.payments_outlined, AppColors.success),
                        _buildStatCard('Borclar', '1,200 AZN', Icons.money_off_outlined, AppColors.error),
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
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        border: Border(right: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 48),
          const Text(
            'Siam Kassam',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 48),
          _buildSidebarItem(Icons.dashboard_outlined, 'Panel', true, () => context.go('/')),
          _buildSidebarItem(Icons.people_outline, 'Müştərilər', false, () => context.push('/customers')),
          _buildSidebarItem(Icons.inventory_2_outlined, 'Məhsullar', false, () => context.push('/products')),
          _buildSidebarItem(Icons.payments_outlined, 'Satış', false, () => context.push('/pos')),
          _buildSidebarItem(Icons.money_off_outlined, 'Borclar', false, () => context.push('/debts')),



          const Spacer(),
          _buildSidebarItem(Icons.logout, 'Çıxış', false, () => ref.read(authProvider.notifier).logout()),
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return GlassCard(
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
    );
  }
}
