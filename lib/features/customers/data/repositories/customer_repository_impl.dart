import '../../domain/entities/customer_entity.dart';
import '../../domain/repositories/customer_repository.dart';
import '../data_sources/customer_local_data_source.dart';
import '../data_sources/customer_remote_data_source.dart';
import '../models/customer_model.dart';
import '../../../../core/network/sync_status.dart';
import 'package:uuid/uuid.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerLocalDataSource localDataSource;
  final CustomerRemoteDataSource remoteDataSource;
  final bool isOnline;

  CustomerRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.isOnline,
  });

  @override
  Future<List<CustomerEntity>> getCustomers(String businessId) async {
    final localModels = await localDataSource.getAll();
    final entities = localModels.map((m) => m.toEntity()).toList();

    if (isOnline) {
      _syncFromRemote(businessId);
    }

    return entities;
  }

  Future<void> _syncFromRemote(String businessId) async {
    try {
      final remoteData = await remoteDataSource.fetchCustomers(businessId);
      final remoteModels = remoteData.map((json) => CustomerModel()
        ..id = json['id']
        ..businessId = businessId
        ..firstName = json['first_name'] ?? ''
        ..lastName = json['last_name'] ?? ''
        ..phone = json['phone']
        ..email = json['email']
        ..creditLimit = (json['credit_limit'] as num?)?.toDouble() ?? 0
        ..totalDebt = (json['total_debt'] as num?)?.toDouble() ?? 0
        ..createdAt = DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String())
        ..updatedAt = DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String())
        ..syncStatus = SyncStatus.synced
      ).toList();

      await localDataSource.saveAll(remoteModels);
    } catch (e) {
      // Handle error
    }
  }

  @override
  Future<void> addCustomer(CustomerEntity customer) async {
    final newCustomer = CustomerModel.fromEntity(customer)
      ..id = customer.id.isEmpty ? const Uuid().v4() : customer.id
      ..syncStatus = isOnline ? SyncStatus.synced : SyncStatus.pendingInsert;

    await localDataSource.save(newCustomer);

    if (isOnline) {
      try {
        await remoteDataSource.upsertCustomer({
          'id': newCustomer.id,
          'business_id': newCustomer.businessId,
          'first_name': newCustomer.firstName,
          'last_name': newCustomer.lastName,
          'phone': newCustomer.phone,
          'email': newCustomer.email,
          'credit_limit': newCustomer.creditLimit,
          'created_at': newCustomer.createdAt.toIso8601String(),
          'updated_at': newCustomer.updatedAt.toIso8601String(),
        });
      } catch (e) {
        newCustomer.syncStatus = SyncStatus.pendingInsert;
        await localDataSource.save(newCustomer);
      }
    }
  }

  @override
  Future<void> updateCustomer(CustomerEntity customer) async {
    final updated = CustomerModel.fromEntity(customer)
      ..updatedAt = DateTime.now()
      ..syncStatus = isOnline ? SyncStatus.synced : SyncStatus.pendingUpdate;

    await localDataSource.save(updated);

    if (isOnline) {
      try {
        await remoteDataSource.upsertCustomer({
          'id': updated.id,
          'first_name': updated.firstName,
          'last_name': updated.lastName,
          'phone': updated.phone,
          'email': updated.email,
          'credit_limit': updated.creditLimit,
          'updated_at': updated.updatedAt.toIso8601String(),
        });
      } catch (e) {
        updated.syncStatus = SyncStatus.pendingUpdate;
        await localDataSource.save(updated);
      }
    }
  }

  @override
  Future<void> syncPendingCustomers() async {
    if (!isOnline) return;
    final pending = await localDataSource.getPendingSync();
    for (final model in pending) {
      try {
        await remoteDataSource.upsertCustomer({
          'id': model.id,
          'business_id': model.businessId,
          'first_name': model.firstName,
          'last_name': model.lastName,
          'phone': model.phone,
          'email': model.email,
          'credit_limit': model.creditLimit,
          'updated_at': model.updatedAt.toIso8601String(),
        });
        model.syncStatus = SyncStatus.synced;
        await localDataSource.save(model);
      } catch (e) {}
    }
  }
}
