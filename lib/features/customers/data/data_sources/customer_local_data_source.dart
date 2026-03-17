import 'package:isar/isar.dart';
import '../models/customer_model.dart';
import '../../../../core/network/sync_status.dart';

class CustomerLocalDataSource {
  final Isar isar;

  CustomerLocalDataSource(this.isar);

  Future<List<CustomerModel>> getAll() async {
    return await isar.customerModels.where().findAll();
  }

  Future<void> save(CustomerModel customer) async {
    await isar.writeTxn(() async {
      await isar.customerModels.put(customer);
    });
  }

  Future<void> saveAll(List<CustomerModel> customers) async {
    await isar.writeTxn(() async {
      await isar.customerModels.putAll(customers);
    });
  }

  Future<CustomerModel?> getById(String id) async {
    return await isar.customerModels.filter().idEqualTo(id).findFirst();
  }

  Future<List<CustomerModel>> getPendingSync() async {
    return await isar.customerModels
        .filter()
        .syncStatusEqualTo(SyncStatus.pendingInsert)
        .or()
        .syncStatusEqualTo(SyncStatus.pendingUpdate)
        .findAll();
  }
}
