import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/glass_input.dart';
import '../../../../shared/widgets/glass_button.dart';

import '../providers/product_provider.dart';
import '../../domain/entities/product_entity.dart';
import 'package:go_router/go_router.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _stockController = TextEditingController(text: '0');
  bool _isLoading = false;

  Future<void> _save() async {
    if (_nameController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final repository = ref.read(productRepositoryProvider);
      await repository.addProduct(ProductEntity(
        id: '', 
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        purchasePrice: double.tryParse(_purchasePriceController.text) ?? 0,
        salePrice: double.tryParse(_salePriceController.text) ?? 0,
        stockQuantity: int.tryParse(_stockController.text) ?? 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
      
      ref.invalidate(productListProvider);
      if (mounted) context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xəta baş verdi: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Məhsul', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: GlassCard(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassInput(labelText: 'Məhsul adı', controller: _nameController),
                  const SizedBox(height: 16),
                  GlassInput(labelText: 'Təsvir', controller: _descriptionController),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: GlassInput(labelText: 'Alış qiyməti', controller: _purchasePriceController, keyboardType: TextInputType.number)),
                      const SizedBox(width: 16),
                      Expanded(child: GlassInput(labelText: 'Satış qiyməti', controller: _salePriceController, keyboardType: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GlassInput(labelText: 'Stok sayı', controller: _stockController, keyboardType: TextInputType.number),
                  const SizedBox(height: 32),
                  GlassButton(
                    onPressed: _isLoading ? () {} : _save,
                    child: _isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Yadda Saxla'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
