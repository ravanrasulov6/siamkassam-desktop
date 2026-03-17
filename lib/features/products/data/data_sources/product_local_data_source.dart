import 'package:isar/isar.dart';
import '../models/product_model.dart';
import '../../../../core/network/sync_status.dart';

class ProductLocalDataSource {
  final Isar isar;

  ProductLocalDataSource(this.isar);

  Future<List<ProductModel>> getAll() async {
    return await isar.productModels.where().findAll();
  }

  Future<void> save(ProductModel product) async {
    await isar.writeTxn(() async {
      await isar.productModels.put(product);
    });
  }

  Future<void> saveAll(List<ProductModel> products) async {
    await isar.writeTxn(() async {
      await isar.productModels.putAll(products);
    });
  }

  Future<ProductModel?> getById(String id) async {
    return await isar.productModels.filter().idEqualTo(id).findFirst();
  }

  Future<void> delete(String id) async {
    await isar.writeTxn(() async {
      await isar.productModels.filter().idEqualTo(id).deleteAll();
    });
  }

  Future<List<ProductModel>> getPendingSync() async {
    return await isar.productModels
        .filter()
        .syncStatusEqualTo(SyncStatus.pendingInsert)
        .or()
        .syncStatusEqualTo(SyncStatus.pendingUpdate)
        .findAll();
  }
}
