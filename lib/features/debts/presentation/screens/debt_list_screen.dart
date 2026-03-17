import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/debt_provider.dart';
import '../../domain/entities/debt_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DebtListScreen extends ConsumerWidget {
  const DebtListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Borclar'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: 'Alacaqlar'),
              Tab(text: 'Borclar'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: AppColors.primary),
              onPressed: () => context.push('/debts/add'),
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE0E7FF), Color(0xFFF1F5F9), Color(0xFFE0E7FF)],
            ),
          ),
          child: TabBarView(
            children: [
              _DebtList(provider: receivablesProvider),
              _DebtList(provider: payablesProvider),
            ],
          ),
        ),
      ),
    );
  }
}

class _DebtList extends ConsumerWidget {
  final Provider<AsyncValue<List<DebtEntity>>> provider;
  const _DebtList({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtsAsync = ref.watch(provider);

    return debtsAsync.when(
      data: (debts) => ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        itemCount: debts.length,
        itemBuilder: (context, index) {
          final debt = debts[index];
          final bool isOverdue = debt.dueDate.isBefore(DateTime.now());
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: ListTile(
                title: Text(debt.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(debt.description ?? ''),
                    const SizedBox(height: 4),
                    Text(
                      'Son tarix: ${DateFormat('dd.MM.yyyy').format(debt.dueDate)}',
                      style: TextStyle(
                        color: isOverdue ? AppColors.error : AppColors.textSecondary,
                        fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  '${debt.amount} AZN',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                onTap: () {},
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Xəta: $err')),
    );
  }
}
