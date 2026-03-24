import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/customers/data/models/customer_model.dart';
import '../../features/products/data/models/product_model.dart';
import '../../features/debts/data/models/debt_model.dart';
import '../../features/pos/data/models/sale_model.dart';
import '../../features/expenses/data/models/expense_model.dart';

final isarProvider = Provider<Isar>((ref) => throw UnimplementedError());

Future<Isar> initIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return await Isar.open(
    [CustomerModelSchema, ProductModelSchema, DebtModelSchema, SaleModelSchema, ExpenseModelSchema],
    directory: dir.path,
  );
}


