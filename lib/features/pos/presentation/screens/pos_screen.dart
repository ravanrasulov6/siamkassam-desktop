import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/glass_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/sale_provider.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../../../customers/presentation/providers/customer_provider.dart';
import '../../domain/entities/sale_entity.dart';
import 'package:go_router/go_router.dart';

class POSScreen extends ConsumerStatefulWidget {
  const POSScreen({super.key});

  @override
  ConsumerState<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends ConsumerState<POSScreen> {
  String? _selectedCustomerId;
  String _paymentMethod = 'Cash';
  bool _isProcessing = false;

  // Removed local _addToCart, now using cartProvider methods

  Future<void> _processSale() async {
    final cart = ref.read(cartProvider);
    if (cart.isEmpty) return;

    setState(() => _isProcessing = true);
    try {
      final subtotal = cart.fold<double>(0, (sum, i) => sum + i.total);
      
      final sale = SaleEntity(
        id: '',
        customerId: _selectedCustomerId,
        items: cart,
        subtotal: subtotal,
        total: subtotal,
        paymentMethod: _paymentMethod,
        createdAt: DateTime.now(),
      );

      await ref.read(saleRepositoryProvider).processSale(sale);
      ref.read(cartProvider.notifier).clear();
      ref.invalidate(saleListProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Satış uğurla tamamlandı')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xəta baş verdi: $e')),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productListProvider);
    final cart = ref.watch(cartProvider);
    final subtotal = cart.fold<double>(0, (sum, i) => sum + i.total);

    return Scaffold(
      appBar: AppBar(
        title: const Text('POS Satış'),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: Row(
          children: [
            // Product Selection Area
            Expanded(
              flex: 2,
              child: productsAsync.when(
                data: (products) => GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _buildAnimatedProductCard(index, product);
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: $e')),
              ),
            ),
            
            // Cart & Finalize Area
            Container(
              width: 400,
              padding: const EdgeInsets.fromLTRB(0, 100, 16, 16),
              child: GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Səbət', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(height: 32),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.length,
                        itemBuilder: (context, index) {
                          final item = cart[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(item.productName),
                            subtitle: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, size: 18),
                                  onPressed: () => ref.read(cartProvider.notifier).updateQuantity(index, item.quantity - 1 > 0 ? item.quantity - 1 : 1),
                                ),
                                Text('${item.quantity.toInt()}'),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, size: 18),
                                  onPressed: () => ref.read(cartProvider.notifier).updateQuantity(index, item.quantity + 1),
                                ),
                                const SizedBox(width: 8),
                                Text('x ${item.price} AZN'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${item.total} AZN', style: const TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                                  onPressed: () => ref.read(cartProvider.notifier).removeItem(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Cəmi:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('$subtotal AZN', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GlassButton(
                      onPressed: _isProcessing ? () {} : _processSale,
                      child: _isProcessing
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Satışı Tamamla'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildAnimatedProductCard(int index, dynamic product) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 50)),
      curve: Curves.easeOutQuad,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: StatefulBuilder(
          builder: (context, setState) {
            bool isHovered = false;
            return MouseRegion(
              onEnter: (_) => setState(() => isHovered = true),
              onExit: (_) => setState(() => isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: isHovered 
                  ? (Matrix4.identity()..translate(0, -4, 0)..scale(1.05))
                  : Matrix4.identity(),
                child: GestureDetector(
                  onTap: () => ref.read(cartProvider.notifier).addProduct(product),
                  child: GlassCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 32, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text(product.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('${product.salePrice} AZN', style: const TextStyle(color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
