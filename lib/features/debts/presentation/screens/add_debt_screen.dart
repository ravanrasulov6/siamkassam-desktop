import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/glass_input.dart';
import '../../../../shared/widgets/glass_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/debt_provider.dart';
import '../../domain/entities/debt_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddDebtScreen extends ConsumerStatefulWidget {
  const AddDebtScreen({super.key});

  @override
  ConsumerState<AddDebtScreen> createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends ConsumerState<AddDebtScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  DebtType _type = DebtType.receivable;
  bool _isLoading = false;

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final repository = ref.read(debtRepositoryProvider);
      await repository.addDebt(DebtEntity(
        id: '',
        name: _nameController.text.trim(),
        amount: double.tryParse(_amountController.text) ?? 0,
        description: _descriptionController.text.trim(),
        type: _type,
        dueDate: _dueDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
      
      ref.invalidate(debtListProvider);
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
        title: const Text('Yeni Borc/Alacaq'),
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: GlassCard(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<DebtType>(
                      segments: [
                        ButtonSegment(value: DebtType.receivable, label: const Text('Alacaq')),
                        ButtonSegment(value: DebtType.payable, label: const Text('Borc')),
                      ],
                      selected: {_type},
                      onSelectionChanged: (val) => setState(() => _type = val.first),
                    ),
                    const SizedBox(height: 24),
                    GlassInput(labelText: 'Ad Soyad / Firma', controller: _nameController),
                    const SizedBox(height: 16),
                    GlassInput(labelText: 'Məbləğ', controller: _amountController, keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    GlassInput(labelText: 'Təsvir', controller: _descriptionController),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Son Ödəmə Tarixi'),
                      subtitle: Text(DateFormat('dd.MM.yyyy').format(_dueDate)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _selectDate,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: AppColors.glassBorder)),
                    ),
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
      ),
    );
  }
}
