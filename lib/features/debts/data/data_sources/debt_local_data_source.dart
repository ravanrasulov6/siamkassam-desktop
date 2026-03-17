import 'package:isar/isar.dart';
import '../models/debt_model.dart';
import '../../domain/entities/debt_entity.dart';
import '../../../../core/network/sync_status.dart';

class DebtLocalDataSource {
  final Isar isar;

  DebtLocalDataSource(this.isar);

  Future<List<DebtModel>> getAll({DebtType? type}) async {
    if (type != null) {
      return await isar.debtModels.filter().typeEqualTo(type).findAll();
    }
    return await isar.debtModels.where().findAll();
  }

  Future<void> save(DebtModel debt) async {
    await isar.writeTxn(() async {
      await isar.debtModels.put(debt);
    });
  }

  Future<void> saveAll(List<DebtModel> debts) async {
    await isar.writeTxn(() async {
      await isar.debtModels.putAll(debts);
    });
  }

  Future<void> delete(String id) async {
    await isar.writeTxn(() async {
      await isar.debtModels.filter().idEqualTo(id).deleteAll();
    });
  }

  Future<List<DebtModel>> getPendingSync() async {
    return await isar.debtModels
        .filter()
        .syncStatusEqualTo(SyncStatus.pendingInsert)
        .or()
        .syncStatusEqualTo(SyncStatus.pendingUpdate)
        .findAll();
  }
}
