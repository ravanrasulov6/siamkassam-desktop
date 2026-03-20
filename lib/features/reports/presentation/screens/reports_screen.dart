import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/kpi_card.dart';
import '../../../../core/constants/app_colors.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  String _activeTab = 'general';
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime.now(),
  );

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
              _buildTabs(),
              const SizedBox(height: 32),
              Expanded(
                child: _buildTabContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF4338CA)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12)],
              ),
              child: const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hesabatlar',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
                ),
                Text(
                  'Biznesinizin maliyyə göstəricilərini izləyin',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
        _buildDateRangePicker(),
      ],
    );
  }

  Widget _buildDateRangePicker() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () async {
          final picked = await showDateRangePicker(
            context: context,
            initialDateRange: _dateRange,
            firstDate: DateTime(2023),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            setState(() => _dateRange = picked);
          }
        },
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
              '${_dateRange.start.day}.${_dateRange.start.month} - ${_dateRange.end.day}.${_dateRange.end.month}.${_dateRange.end.year}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = [
      {'id': 'general', 'label': 'Ümumi Analiz', 'icon': Icons.analytics_outlined},
      {'id': 'sales', 'label': 'Satış Hesabatları', 'icon': Icons.shopping_cart_outlined},
      {'id': 'expenses', 'label': 'Xərc Hesabatları', 'icon': Icons.payments_outlined},
      {'id': 'debts', 'label': 'Borc & Kredit', 'icon': Icons.credit_card_outlined},
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
                boxShadow: isActive ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 8)] : null,
              ),
              child: Row(
                children: [
                  Icon(tab['icon'] as IconData, color: isActive ? Colors.white : AppColors.textSecondary, size: 20),
                  const SizedBox(width: 10),
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

  Widget _buildTabContent() {
    switch (_activeTab) {
      case 'general':
        return _buildGeneralTab();
      case 'sales':
        return _buildSalesTab();
      case 'expenses':
        return _buildExpensesTab();
      case 'debts':
        return _buildDebtsTab();
      default:
        return const Center(child: Text('Tezliklə...'));
    }
  }

  Widget _buildGeneralTab() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: KPICard(
                title: 'ÜMUMİ SATIŞLAR',
                value: '12,450 AZN',
                icon: Icons.trending_up_rounded,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: KPICard(
                title: 'ÜMUMİ XƏRCLƏR',
                value: '4,120 AZN',
                icon: Icons.trending_down_rounded,
                color: AppColors.error,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF4338CA)]),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 15)],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('XALİS MƏNFƏƏT', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        Icon(Icons.auto_graph_rounded, color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text('8,330 AZN', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.memory_rounded, color: AppColors.primary, size: 32),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                      child: const Text('AI Analiz'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.insights_rounded, size: 80, color: AppColors.primary.withValues(alpha: 0.2)),
                  const SizedBox(height: 16),
                  const Text('Dinamik qrafiklər tezliklə əlavə olunacaq', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSalesTab() {
    return const GlassCard(
      padding: EdgeInsets.all(32),
      child: Center(child: Text('Satış hesabatları burada göstəriləcək')),
    );
  }

  Widget _buildExpensesTab() {
    return const GlassCard(
      padding: EdgeInsets.all(32),
      child: Center(child: Text('Xərc analizi burada göstəriləcək')),
    );
  }

  Widget _buildDebtsTab() {
    return const GlassCard(
      padding: EdgeInsets.all(32),
      child: Center(child: Text('Borc və kredit balansı burada göstəriləcək')),
    );
  }
}
