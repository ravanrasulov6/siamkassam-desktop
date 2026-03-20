import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _activeTab = 'profile';

  final List<Map<String, dynamic>> _tabs = [
    {'id': 'profile', 'label': 'Biznes Profili', 'icon': Icons.business_center_outlined},
    {'id': 'users', 'label': 'İstifadəçilər & Rollar', 'icon': Icons.people_outline_rounded},
    {'id': 'receipts', 'label': 'Çek Tənzimləmələri', 'icon': Icons.print_outlined},
    {'id': 'whatsapp', 'label': 'WhatsApp İnteqrasiyası', 'icon': Icons.message_outlined},
  ];

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 280, child: _buildSidebar()),
                    const SizedBox(width: 32),
                    Expanded(child: _buildContent()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF64748B),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: const Color(0xFF64748B).withValues(alpha: 0.2), blurRadius: 10)],
          ),
          child: const Icon(Icons.settings_outlined, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tənzimləmələr',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
            ),
            Text(
              'Sistem və biznes parametrlərini buradan idarə edin',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        GlassCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: _tabs.map((tab) {
              final isActive = _activeTab == tab['id'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: InkWell(
                  onTap: () => setState(() => _activeTab = tab['id']),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(tab['icon'] as IconData, color: isActive ? Colors.white : AppColors.textSecondary, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          tab['label'] as String,
                          style: TextStyle(
                            color: isActive ? Colors.white : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(20),
          color: AppColors.primary.withValues(alpha: 0.05),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.shield_outlined, size: 16, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('Təhlükəsizlik', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Bütün məlumatlar Supabase tərəfindən yüksək səviyyədə qorunur.',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (_activeTab) {
      case 'profile':
        return _buildProfileSettings();
      case 'users':
        return _buildUsersSettings();
      case 'receipts':
        return _buildReceiptSettings();
      case 'whatsapp':
        return _buildWhatsAppSettings();
      default:
        return Container();
    }
  }

  Widget _buildProfileSettings() {
    return GlassCard(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Biznes Profili', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildTextField('Biznesin Adı', Icons.store_outlined, 'Məs: Siam Store'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildTextField('VÖEN', Icons.tag_rounded, '1234567890')),
              const SizedBox(width: 20),
              Expanded(child: _buildTextField('Əlaqə Nömrəsi', Icons.phone_outlined, '+994 50 000 00 00')),
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField('Ünvan', Icons.location_on_outlined, 'Məs: Bakı ş, Nizami küç 12', maxLines: 3),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save_outlined),
              label: const Text('Yadda Saxla'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersSettings() {
    return GlassCard(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('İstifadəçilər & Rollar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('İstifadəçi Əlavə Et'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                _buildUserRow('Rəvan Rəsulov', 'Admin', 'Aktiv'),
                _buildUserRow('Siam Kassam', 'Kassir', 'Aktiv'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(String name, String role, String status) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: AppColors.primary.withValues(alpha: 0.1), child: Text(name[0], style: const TextStyle(color: AppColors.primary))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Son giriş: bu gün', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(role, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 11)),
          ),
          const SizedBox(width: 24),
          Row(
            children: [
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(status, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptSettings() {
    return GlassCard(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Çek Tənzimləmələri', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildTextField('Çek Altlıq Mətni', Icons.text_fields_rounded, 'Alış-verişiniz üçün təşəkkürlər!'),
          const SizedBox(height: 24),
          _buildToggleTile('Biznesin adını göstər', true),
          _buildToggleTile('Ünvanı göstər', true),
          _buildToggleTile('Telefon nömrəsini göstər', true),
          _buildToggleTile('Mağaza loqosunu göstər', true),
        ],
      ),
    );
  }

  Widget _buildWhatsAppSettings() {
    return GlassCard(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF25D366).withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.message_rounded, color: Color(0xFF25D366), size: 48),
              ),
              const SizedBox(height: 24),
              const Text('WhatsApp İnteqrasiyası', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                'Siam Kassam-ı WhatsApp ilə əlaqələndirərək səsli mesajlarla məhsul əlavə edə, satışlar barədə məlumat ala bilərsiniz.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 32),
              _buildTextField('WhatsApp Nömrəniz', Icons.phone_android_outlined, '+994 50 000 00 00'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Təsdiqləmə Kodu Göndər'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleTile(String title, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Switch(value: value, onChanged: (v) {}, activeColor: AppColors.primary),
        ],
      ),
    );
  }
}
