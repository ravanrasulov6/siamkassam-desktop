import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _activeTab = 'profile';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9), Color(0xFFF8FAFC)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildTabs(),
              const SizedBox(height: 32),
              Expanded(
                child: _buildTabContent(user),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tənzimləmələr',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
        ),
        Text('Sistem tənzimləmələri və profil məlumatları', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
      ],
    );
  }

  Widget _buildTabs() {
    final tabs = [
      {'id': 'profile', 'label': 'Profil', 'icon': Icons.person_outline},
      {'id': 'business', 'label': 'Biznes', 'icon': Icons.business_outlined},
      {'id': 'users', 'label': 'İstifadəçilər', 'icon': Icons.group_outlined},
      {'id': 'system', 'label': 'Sistem', 'icon': Icons.settings_outlined},
    ];

    return Row(
      children: tabs.map((tab) {
        final isActive = _activeTab == tab['id'];
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: InkWell(
            onTap: () => setState(() => _activeTab = tab['id'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(tab['icon'] as IconData, color: isActive ? Colors.white : AppColors.textSecondary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    tab['label'] as String,
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTabContent(user) {
    switch (_activeTab) {
      case 'profile':
        return _buildProfileTab(user);
      case 'business':
        return _buildBusinessTab(user);
      case 'users':
        return _buildUsersTab();
      case 'system':
        return _buildSystemTab();
      default:
        return const SizedBox();
    }
  }

  Widget _buildProfileTab(user) {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(fontSize: 32, color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.email ?? 'Yüklənir...', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const Text('Administrator', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),
            _buildSettingRow('E-poçt', user?.email ?? '-'),
            _buildSettingRow('ID', user?.id ?? '-'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Şifrəni Dəyiş'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessTab(user) {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Biznes Məlumatları', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildSettingRow('Biznes ID', user?.businessId ?? 'Təyin edilməyib'),
          const SizedBox(height: 32),
          const Text('Kateqoriyalar', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('Pərakəndə')),
              Chip(label: Text('Market')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return const GlassCard(
      child: Center(child: Text('İstifadəçi idarəetməsi tezliklə...')),
    );
  }

  Widget _buildSystemTab() {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: const Text('Bildirişlər'),
            subtitle: const Text('Sistem bildirişlərini aktivləşdirin'),
            value: true,
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(width: 150, child: Text(label, style: const TextStyle(color: AppColors.textSecondary))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
