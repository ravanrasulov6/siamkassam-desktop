import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/kpi_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/product_provider.dart';
import 'package:go_router/go_router.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final _searchController = TextEditingController();
  String _categoryFilter = 'all';
  String _stockFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productListProvider);

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
              _buildHeader(context),
              const SizedBox(height: 32),

              // KPI Cards for products
              productsAsync.when(
                data: (products) => _buildKPICards(products),
                loading: () => _buildKPICards([], isLoading: true),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 32),

              _buildFilters(),
              const SizedBox(height: 24),

              Expanded(
                child: productsAsync.when(
                  data: (products) {
                    final filtered = products.where((p) {
                      final matchesSearch = p.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                          (p.barcode ?? '').contains(_searchController.text);
                      final matchesCategory = _categoryFilter == 'all' || p.category == _categoryFilter;
                      
                      bool matchesStock = true;
                      if (_stockFilter == 'low') {
                        matchesStock = p.stockQuantity <= p.minStockThreshold && p.stockQuantity > 0;
                      } else if (_stockFilter == 'out') {
                        matchesStock = p.stockQuantity <= 0;
                      }
                      
                      return matchesSearch && matchesCategory && matchesStock;
                    }).toList();

                    if (filtered.isEmpty) {
                      return _buildEmptyState();
                    }

                    return _buildProductList(filtered);
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
              'Məhsullar',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
            ),
            Text(
              'Bütün məhsul və xidmətlərinizi buradan idarə edin',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.folder_open_rounded),
              label: const Text('Kateqoriyalar'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => context.push('/products/add'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Yeni Məhsul'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKPICards(List products, {bool isLoading = false}) {
    final totalProducts = products.length;
    final lowStock = products.where((p) => p.stockQuantity <= p.minStockThreshold && p.stockQuantity > 0).length;
    final outOfStock = products.where((p) => p.stockQuantity <= 0).length;

    return Row(
      children: [
        Expanded(
          child: KPICard(
            title: 'Ümumi Məhsul',
            value: totalProducts.toString(),
            icon: Icons.inventory_2_outlined,
            color: AppColors.primary,
            isLoading: isLoading,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: KPICard(
            title: 'Aşağı Stok',
            value: lowStock.toString(),
            icon: Icons.warning_amber_rounded,
            color: Colors.orange,
            isLoading: isLoading,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: KPICard(
            title: 'Bitmiş Məhsul',
            value: outOfStock.toString(),
            icon: Icons.error_outline_rounded,
            color: AppColors.error,
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
                hintText: 'Məhsul adı və ya barkod ilə axtar...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
          const VerticalDivider(width: 32),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _categoryFilter,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('Bütün Kateqoriyalar')),
              ],
              onChanged: (val) => setState(() => _categoryFilter = val!),
            ),
          ),
          const VerticalDivider(width: 32),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _stockFilter,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('Bütün Stok')),
                DropdownMenuItem(value: 'low', child: Text('Aşağı')),
                DropdownMenuItem(value: 'out', child: Text('Bitmiş')),
              ],
              onChanged: (val) => setState(() => _stockFilter = val!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List products) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('Məhsul', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Kateqoriya', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Alış', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Satış', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Stok', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 100),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: products.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.glassBorder),
              itemBuilder: (context, index) {
                final product = products[index];
                
                Color stockColor = AppColors.success;
                if (product.stockQuantity <= 0) {
                  stockColor = AppColors.error;
                } else if (product.stockQuantity <= product.minStockThreshold) {
                  stockColor = Colors.orange;
                }

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: stockColor.withOpacity(0.1),
                    child: Text(
                      product.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: stockColor),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            if (product.barcode != null)
                              Text(product.barcode!, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          ],
                        ),
                      ),
                      Expanded(child: Text(product.category ?? '-')),
                      Expanded(child: Text('${product.purchasePrice} AZN')),
                      Expanded(child: Text('${product.salePrice} AZN', style: const TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: stockColor),
                            ),
                            const SizedBox(width: 8),
                            Text('${product.stockQuantity} ${product.unit ?? 'ədəd'}'),
                          ],
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
          Icon(Icons.inventory_2_outlined, size: 80, color: AppColors.textSecondary.withOpacity(0.2)),
          const SizedBox(height: 16),
          const Text('Məhsul tapılmadı.', style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
