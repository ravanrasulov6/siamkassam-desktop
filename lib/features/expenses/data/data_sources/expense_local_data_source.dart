import 'package:isar/isar.dart';
import '../models/expense_model.dart';
import '../../domain/entities/expense_entity.dart';
import '../../../../core/network/sync_status.dart';

class ExpenseLocalDataSource {
  final Isar isar;

  ExpenseLocalDataSource(this.isar);

  Future<List<ExpenseModel>> getAll() async {
    return isar.expenseModels.where().sortByCreatedAtDesc().findAll();
  }

  Future<void> save(ExpenseModel model) async {
    await isar.writeTxn(() async {
      await isar.expenseModels.put(model);
    });
  }

  Future<void> saveAll(List<ExpenseModel> models) async {
    await isar.writeTxn(() async {
      await isar.expenseModels.putAll(models);
    });
  }

  Future<void> delete(String id) async {
    await isar.writeTxn(() async {
      await isar.expenseModels.filter().idEqualTo(id).deleteAll();
    });
  }

  Future<List<ExpenseModel>> getPendingSync() async {
    return isar.expenseModels.filter()
      .syncStatusEqualTo(SyncStatus.pendingInsert)
      .or()
      .syncStatusEqualTo(SyncStatus.pendingUpdate)
      .findAll();
  }
}
