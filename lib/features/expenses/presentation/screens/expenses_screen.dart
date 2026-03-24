import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added for ConsumerStatefulWidget
import '../providers/expense_provider.dart';
import '../../domain/entities/expense_entity.dart';
import 'package:intl/intl.dart';
import '../../../../shared/widgets/kpi_card.dart'; // Assuming KPICard is a shared widget

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expenseListProvider);

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
          child: expensesAsync.when(
            data: (expenses) {
              final filteredExpenses = expenses.where((e) {
                final query = _searchController.text.toLowerCase();
                return e.category.toLowerCase().contains(query) ||
                    e.description.toLowerCase().contains(query);
              }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildStats(expenses),
                  const SizedBox(height: 32),
                  _buildFilters(),
                  const SizedBox(height: 24),
                  Expanded(child: _buildExpensesTable(filteredExpenses)),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Xəta: $err')),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xərclər',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
            ),
            Text('Biznes xərclərinizi buradan idarə edin', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddExpenseDialog(),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Yeni Xərc'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildStats(List<ExpenseEntity> expenses) {
    final now = DateTime.now();
    final todayExpenses = expenses.where((e) => e.createdAt.day == now.day && e.createdAt.month == now.month && e.createdAt.year == now.year);
    final todayTotal = todayExpenses.fold(0.0, (sum, e) => sum + e.amount);

    final monthExpenses = expenses.where((e) => e.createdAt.month == now.month && e.createdAt.year == now.year);
    final monthTotal = monthExpenses.fold(0.0, (sum, e) => sum + e.amount);

    return Row(
      children: [
        Expanded(
          child: KPICard(
            title: 'Bugünkü Xərc',
            value: '${todayTotal.toStringAsFixed(2)} AZN',
            subtitle: 'Bugün cəmi ${todayExpenses.length} əməliyyat',
            icon: Icons.today_rounded,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: KPICard(
            title: 'Bu Ayın Xərci',
            value: '${monthTotal.toStringAsFixed(2)} AZN',
            subtitle: 'Bu ay üzrə cəmi',
            icon: Icons.calendar_month_rounded,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: KPICard(
            title: 'Ən Böyük Xərc',
            value: '${(expenses.isEmpty ? 0 : expenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b)).toStringAsFixed(2)} AZN',
            subtitle: 'Təkrarolunmaz xərc',
            icon: Icons.trending_up_rounded,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() {}),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                hintText: 'Kateqoriya və ya təsvir axtar...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpensesTable(List<ExpenseEntity> expenses) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          child: expenses.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: Text('Hələ ki xərc yoxdur')),
            )
          : DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
            horizontalMargin: 24,
            columnSpacing: 40,
            columns: const [
              DataColumn(label: Text('KATEQORİYA', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('TƏSVİR', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('MƏBLƏĞ', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('TARİX', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ƏMƏLLƏR', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: expenses.map((expense) {
              return DataRow(cells: [
                DataCell(Text(expense.category, style: const TextStyle(fontWeight: FontWeight.w600))),
                DataCell(Text(expense.description)),
                DataCell(Text('${expense.amount.toStringAsFixed(2)} AZN', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent))),
                DataCell(Text(DateFormat('dd.MM.yyyy').format(expense.createdAt))),
                DataCell(Row(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textSecondary)),
                    IconButton(onPressed: () => _deleteExpense(expense.id), icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent)),
                  ],
                )),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showAddExpenseDialog() {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'Digər';
    final categories = ['İcarə', 'Maaşlar', 'Kommunal', 'Marketing', 'İnventar', 'Digər'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Yeni Xərc Əlavə Et'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setDialogState(() => selectedCategory = val!),
                decoration: const InputDecoration(labelText: 'Kateqoriya'),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Məbləğ (AZN)'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Təsvir'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Ləğv Et')),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount > 0) {
                  ref.read(expenseRepositoryProvider).addExpense(
                    ExpenseEntity(
                      id: '',
                      category: selectedCategory,
                      amount: amount,
                      description: descriptionController.text,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                  ).then((_) {
                    ref.read(expenseListProvider.notifier).refresh();
                    Navigator.pop(context);
                  });
                }
              },
              child: const Text('Əlavə Et'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteExpense(String id) {
    ref.read(expenseRepositoryProvider).deleteExpense(id).then((_) {
      ref.read(expenseListProvider.notifier).refresh();
    });
  }
}
