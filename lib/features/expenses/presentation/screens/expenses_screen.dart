import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../core/constants/app_colors.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
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
              _buildStats(),
              const SizedBox(height: 32),
              Expanded(child: _buildExpensesList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Yeni Xərc', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: const Icon(Icons.payments_rounded, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xərclər',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
                ),
                Text(
                  'Biznes xərclərinizi idarə edin',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _buildStatCard('BU AY', '2,450.00 AZN', Icons.calendar_today_outlined, AppColors.primary),
        const SizedBox(width: 24),
        _buildStatCard('BU GÜN', '120.00 AZN', Icons.today_outlined, AppColors.success),
        const SizedBox(width: 24),
        _buildStatCard('ƏN ÇOX XƏRC', 'İcarə', Icons.trending_up, AppColors.error),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesList() {
    final categories = [
      {'name': 'İcarə', 'amount': 1500.0, 'color': Colors.blue},
      {'name': 'Maaşlar', 'amount': 2800.0, 'color': Colors.indigo},
      {'name': 'Logistika', 'amount': 450.0, 'color': Colors.orange},
      {'name': 'Kommunal', 'amount': 220.0, 'color': Colors.cyan},
      {'name': 'Digər', 'amount': 130.0, 'color': Colors.grey},
    ];

    double total = categories.fold(0, (sum, item) => sum + (item['amount'] as double));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: GlassCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kateqoriya Üzrə Analiz', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                ...categories.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text('${(c['amount'] as double).toStringAsFixed(2)} AZN', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (c['amount'] as double) / total,
                        backgroundColor: (c['color'] as Color).withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation(c['color'] as Color),
                        borderRadius: BorderRadius.circular(5),
                        minHeight: 8,
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Icon(Icons.pie_chart_outline, size: 64, color: AppColors.primary),
                const SizedBox(height: 16),
                const Text('Xərc Strukturu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                const Text(
                  'Bu ay xərcləriniz keçən aya nisbətən 5% azalıb. Ən böyük xərc maddəniz "Maaşlar" kateqoriyasıdır.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
