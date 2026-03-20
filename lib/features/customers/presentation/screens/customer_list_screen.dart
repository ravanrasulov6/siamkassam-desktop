import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/glass_input.dart';
import '../../../../shared/widgets/kpi_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/customer_provider.dart';
import 'package:go_router/go_router.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final _searchController = TextEditingController();
  String _statusFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customerListProvider);

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
              // Header
              _buildHeader(context),
              const SizedBox(height: 32),

              // KPI Cards
              customersAsync.when(
                data: (customers) => _buildKPICards(customers),
                loading: () => _buildKPICards([], isLoading: true),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 32),

              // Filters
              _buildFilters(),
              const SizedBox(height: 24),

              // Content List
              Expanded(
                child: customersAsync.when(
                  data: (customers) {
                    final filtered = customers.where((c) {
                      final matchesSearch = c.fullName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                          (c.phone ?? '').contains(_searchController.text);
                      final matchesStatus = _statusFilter == 'all' || 
                          (_statusFilter == 'debt' && c.totalDebt > 0);
                      return matchesSearch && matchesStatus;
                    }).toList();

                    if (filtered.isEmpty) {
                      return _buildEmptyState();
                    }

                    return _buildCustomerList(filtered);
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Xəta: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Müştərilər',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
            ),
            Text(
              'Müştəri bazası və borc idarəetməsi',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => context.push('/customers/add'),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Yeni Müştəri'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildKPICards(List customers, {bool isLoading = false}) {
    final totalCustomers = customers.length;
    final totalDebt = customers.fold<double>(0, (sum, c) => sum + (c.totalDebt ?? 0));
    final limitReached = customers.where((c) => c.creditLimit > 0 && c.totalDebt >= c.creditLimit).length;

    return Row(
      children: [
        Expanded(
          child: KPICard(
            title: 'Ümumi Müştəri',
            value: totalCustomers.toString(),
            icon: Icons.people_outline,
            color: AppColors.primary,
            isLoading: isLoading,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: KPICard(
            title: 'Ümumi Alacaqlar',
            value: '${totalDebt.toStringAsFixed(2)} AZN',
            icon: Icons.trending_down_rounded,
            color: AppColors.error,
            isLoading: isLoading,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: KPICard(
            title: 'Limitə Çatanlar',
            value: limitReached.toString(),
            icon: Icons.error_outline_rounded,
            color: Colors.orange,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Ad və ya telefon ilə axtar...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
          const VerticalDivider(width: 32),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _statusFilter,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('Bütün Müştərilər')),
                  DropdownMenuItem(value: 'debt', child: Text('Borcu Olanlar')),
                ],
                onChanged: (val) => setState(() => _statusFilter = val!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerList(List customers) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('Müştəri', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Kredit Limiti', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Borc', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 100), // Actions
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: customers.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.glassBorder),
              itemBuilder: (context, index) {
                final customer = customers[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      customer.firstName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(customer.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text(customer.phone ?? 'Nömrə yoxdur', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          ],
                        ),
                      ),
                      Expanded(child: Text(customer.creditLimit > 0 ? '${customer.creditLimit} AZN' : 'Limitsiz')),
                      Expanded(
                        child: Text(
                          '${customer.totalDebt} AZN',
                          style: TextStyle(
                            color: customer.totalDebt > 0 ? AppColors.error : AppColors.textSecondary,
                            fontWeight: customer.totalDebt > 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () {}),
                            IconButton(icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20), onPressed: () {}),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_alt_outlined, size: 80, color: AppColors.textSecondary.withOpacity(0.2)),
          const SizedBox(height: 16),
          const Text('Müştəri tapılmadı.', style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
