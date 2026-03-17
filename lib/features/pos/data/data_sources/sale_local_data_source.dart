import 'package:isar/isar.dart';
import '../models/sale_model.dart';
import '../../../../core/network/sync_status.dart';

class SaleLocalDataSource {
  final Isar isar;

  SaleLocalDataSource(this.isar);

  Future<List<SaleModel>> getAll() async {
    return await isar.saleModels.where().sortByCreatedAtDesc().findAll();
  }

  Future<void> save(SaleModel sale) async {
    await isar.writeTxn(() async {
      await isar.saleModels.put(sale);
    });
  }

  Future<void> saveAll(List<SaleModel> sales) async {
    await isar.writeTxn(() async {
      await isar.saleModels.putAll(sales);
    });
  }

  Future<List<SaleModel>> getPendingSync() async {
    return await isar.saleModels
        .filter()
        .syncStatusEqualTo(SyncStatus.pendingInsert)
        .findAll();
  }
}
