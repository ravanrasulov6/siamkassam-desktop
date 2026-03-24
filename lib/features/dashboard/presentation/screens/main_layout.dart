import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1), // Solves white-on-white edge issue
          borderRadius: BorderRadius.circular(12), // Match typical rounded windows (optional for Windows 11)
          color: AppColors.background,
        ),
        child: Column(
          children: [
            // Custom Title Bar
            _buildCustomTitleBar(),
            
            // Main Window Content (Sidebar + Active Screen)
            Expanded(
              child: Row(
                children: [
                  // Persistent Sidebar
                  _buildSidebar(context, ref),
                  
                  // Active Screen Content provided by ShellRoute
                  Expanded(
                    child: child,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTitleBar() {
    return DragToMoveArea(
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Icon(Icons.business_center, size: 16, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
            const Text(
              'Siam Kassam',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            const Spacer(),
            const WindowCaption(
              brightness: Brightness.light,
              backgroundColor: Colors.transparent,
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
          const SizedBox(height: 32),
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
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
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
              ],
            ),
          ),
          const Divider(height: 1),
          _buildSidebarItem(Icons.logout, 'Çıxış', false, () {
            ref.read(authProvider.notifier).logout();
            context.go('/login');
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          leading: Icon(icon, color: isActive ? AppColors.primary : AppColors.textSecondary),
          title: Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          onTap: onTap,
          selected: isActive,
          selectedTileColor: AppColors.primary.withOpacity(0.1),
          hoverColor: AppColors.glassWhite,
        ),
      ),
    );
  }
}
