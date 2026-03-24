import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/kpi_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../pos/presentation/providers/sale_provider.dart';
import '../../../pos/domain/entities/sale_entity.dart';
import '../../../expenses/presentation/providers/expense_provider.dart';
import '../../../expenses/domain/entities/expense_entity.dart';
import '../../../debts/presentation/providers/debt_provider.dart';
import '../../../debts/domain/entities/debt_entity.dart';
import 'package:intl/intl.dart';

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
    final salesAsync = ref.watch(saleListProvider);
    final expensesAsync = ref.watch(expenseListProvider);
    final debtsAsync = ref.watch(debtListProvider);

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
          child: (salesAsync.isLoading || expensesAsync.isLoading || debtsAsync.isLoading)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildTabs(),
                const SizedBox(height: 32),
                Expanded(
                  child: _buildTabContent(
                    sales: salesAsync.value ?? [],
                    expenses: expensesAsync.value ?? [],
                    debts: debtsAsync.value ?? [],
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

  Widget _buildTabContent({required List<SaleEntity> sales, required List<ExpenseEntity> expenses, required List<DebtEntity> debts}) {
    // Filter by date range
    final filteredSales = sales.where((s) => s.createdAt.isAfter(_dateRange.start) && s.createdAt.isBefore(_dateRange.end.add(const Duration(days: 1)))).toList();
    final filteredExpenses = expenses.where((e) => e.createdAt.isAfter(_dateRange.start) && e.createdAt.isBefore(_dateRange.end.add(const Duration(days: 1)))).toList();

    switch (_activeTab) {
      case 'general':
        return _buildGeneralTab(filteredSales, filteredExpenses);
      case 'sales':
        return _buildSalesTab(filteredSales);
      case 'expenses':
        return _buildExpensesTab(filteredExpenses);
      case 'debts':
        return _buildDebtsTab(debts);
      default:
        return const Center(child: Text('Tezliklə...'));
    }
  }

  Widget _buildGeneralTab(List<SaleEntity> sales, List<ExpenseEntity> expenses) {
    final totalSales = sales.fold(0.0, (sum, s) => sum + s.total);
    final totalExpenses = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final netProfit = totalSales - totalExpenses;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: KPICard(
                title: 'ÜMUMİ SATIŞLAR',
                value: '${NumberFormat('#,###.00').format(totalSales)} AZN',
                icon: Icons.trending_up_rounded,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: KPICard(
                title: 'ÜMUMİ XƏRCLƏR',
                value: '${NumberFormat('#,###.00').format(totalExpenses)} AZN',
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
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 15)],
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('XALİS MƏNFƏƏT', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        Icon(Icons.auto_graph_rounded, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('${NumberFormat('#,###.00').format(netProfit)} AZN', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Analitik İcmal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.insights_rounded, size: 80, color: AppColors.primary.withValues(alpha: 0.1)),
                        const SizedBox(height: 16),
                        Text('Seçilmiş tarixlər üzrə ${sales.length} satış və ${expenses.length} xərc sənədi tapıldı.', style: const TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSalesTab(List<SaleEntity> sales) {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Text('Satış Hesabatı (${sales.length} sənəd)', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(height: 32),
          Expanded(
            child: sales.isEmpty 
            ? const Center(child: Text('Məlumat yoxdur'))
            : ListView.builder(
                itemCount: sales.length,
                itemBuilder: (context, index) {
                  final s = sales[index];
                  return ListTile(
                    title: Text(s.customerName ?? 'Anonim Müştəri'),
                    subtitle: Text(DateFormat('dd.MM.yyyy HH:mm').format(s.createdAt)),
                    trailing: Text('${s.total.toStringAsFixed(2)} AZN', style: const TextStyle(fontWeight: FontWeight.bold)),
                  );
                },
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesTab(List<ExpenseEntity> expenses) {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Text('Xərc Hesabatı (${expenses.length} sənəd)', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(height: 32),
          Expanded(
            child: expenses.isEmpty 
            ? const Center(child: Text('Məlumat yoxdur'))
            : ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final e = expenses[index];
                  return ListTile(
                    title: Text(e.category),
                    subtitle: Text(e.description),
                    trailing: Text('${e.amount.toStringAsFixed(2)} AZN', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  );
                },
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebtsTab(List<DebtEntity> debts) {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Center(child: Text('Borc & Kredit balansı: ${debts.length} aktiv qeyd')),
    );
  }
}
