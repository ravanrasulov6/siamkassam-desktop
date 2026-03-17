import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/product_provider.dart';
import 'package:go_router/go_router.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Məhsullar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => context.push('/products/add'),
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
        child: productsAsync.when(
          data: (products) => ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.glassWhite,
                      child: Icon(Icons.inventory_2_outlined, color: AppColors.primary),
                    ),
                    title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${product.stockQuantity} ədəd - ${product.salePrice} AZN'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Details
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
