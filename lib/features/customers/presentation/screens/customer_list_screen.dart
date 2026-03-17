import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/customer_provider.dart';
import 'package:go_router/go_router.dart';

class CustomerListScreen extends ConsumerWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customerListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Müştərilər'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => context.push('/customers/add'),
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
        child: customersAsync.when(
          data: (customers) => ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: ListTile(
                    title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(customer.phone ?? 'Nömrə yoxdur'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to details
                    },
                  ),
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Xəta: $err')),
        ),
      ),
    );
  }
}
