import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../customers/presentation/providers/customer_provider.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../../../pos/presentation/providers/sale_provider.dart';
import '../../../debts/presentation/providers/debt_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final customers = ref.watch(customerListProvider);
    final products = ref.watch(productListProvider);
    final sales = ref.watch(saleListProvider);
    final debts = ref.watch(debtListProvider);

    final currencyFormat = NumberFormat.currency(symbol: '₼', decimalDigits: 2);
    
    // Calculate Today's Sales
    final now = DateTime.now();
    final todaySales = sales.value?.where((s) => 
      s.createdAt.day == now.day && 
      s.createdAt.month == now.month && 
      s.createdAt.year == now.year
    ).fold(0.0, (sum, s) => sum! + s.total) ?? 0.0;

    // Calculate Total Debts (Receivables - Payables, or just Receivables for simplicity)
    final totalDebts = debts.value?.fold(0.0, (sum, d) => sum! + d.amount) ?? 0.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
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
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user?.fullName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
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
                _buildAnimatedStatCard(0, 'Müştərilər', customers.value?.length.toString() ?? '...', Icons.people_outline, AppColors.primary),
                _buildAnimatedStatCard(1, 'Məhsullar', products.value?.length.toString() ?? '...', Icons.inventory_2_outlined, Colors.orange),
                _buildAnimatedStatCard(2, 'Bugünkü Satış', currencyFormat.format(todaySales), Icons.payments_outlined, AppColors.success),
                _buildAnimatedStatCard(3, 'Borclar', currencyFormat.format(totalDebts), Icons.money_off_outlined, AppColors.error),
              ],
            ),
            
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Son Fəaliyyətlər', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => context.go('/sales'),
                  child: const Text('Hamısına bax →'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(0),
              child: sales.when(
                data: (list) {
                  final recentSales = list.take(10).toList();
                  if (recentSales.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: Text('Hələ heç bir fəaliyyət yoxdur.', style: TextStyle(color: AppColors.textSecondary))),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentSales.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.glassBorder),
                    itemBuilder: (context, index) {
                      final sale = recentSales[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: const Icon(Icons.shopping_cart_outlined, size: 20, color: AppColors.primary),
                        ),
                        title: Text('Satış #${sale.id.substring(0, 5).toUpperCase()}'),
                        subtitle: Text(DateFormat('HH:mm').format(sale.createdAt)),
                        trailing: Text(
                          currencyFormat.format(sale.total),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, _) => Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(child: Text('Xəta: $err')),
                ),
              ),
            ),
          ],
        ),
      ),
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
