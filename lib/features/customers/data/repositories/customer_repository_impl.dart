import '../../domain/entities/customer_entity.dart';
import '../../domain/repositories/customer_repository.dart';
import '../data_sources/customer_local_data_source.dart';
import '../data_sources/customer_remote_data_source.dart';
import '../models/customer_model.dart';
import '../../../../core/network/sync_status.dart';
import '../../../../core/network/connectivity_provider.dart';
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
  Future<List<CustomerEntity>> getCustomers() async {
    // 1. Return local data immediately
    final localModels = await localDataSource.getAll();
    final entities = localModels.map((m) => m.toEntity()).toList();

    // 2. If online, fetch remote in background and update local
    if (isOnline) {
      _syncFromRemote();
    }

    return entities;
  }

  Future<void> _syncFromRemote() async {
    try {
      final remoteData = await remoteDataSource.fetchCustomers();
      final remoteModels = remoteData.map((json) => CustomerModel()
        ..id = json['id']
        ..name = json['name']
        ..phone = json['phone']
        ..createdAt = DateTime.parse(json['created_at'])
        ..updatedAt = DateTime.parse(json['updated_at'])
        ..syncStatus = SyncStatus.synced
      ).toList();

      await localDataSource.saveAll(remoteModels);
    } catch (e) {
      // Log or handle error
    }
  }

  @override
  Future<void> addCustomer(CustomerEntity customer) async {
    final remoteId = const Uuid().v4();
    final newCustomer = CustomerEntity(
      id: remoteId,
      name: customer.name,
      phone: customer.phone,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      syncStatus: isOnline ? SyncStatus.synced : SyncStatus.pendingInsert,
    );

    // Save locally first
    await localDataSource.save(CustomerModel.fromEntity(newCustomer));

    // Try to sync if online
    if (isOnline) {
      try {
        await remoteDataSource.upsertCustomer({
          'id': newCustomer.id,
          'name': newCustomer.name,
          'phone': newCustomer.phone,
          'created_at': newCustomer.createdAt.toIso8601String(),
          'updated_at': newCustomer.updatedAt.toIso8601String(),
        });
      } catch (e) {
        // If remote fails, mark as pending
        final pending = CustomerModel.fromEntity(newCustomer)..syncStatus = SyncStatus.pendingInsert;
        await localDataSource.save(pending);
      }
    }
  }

  @override
  Future<void> updateCustomer(CustomerEntity customer) async {
    final updated = CustomerEntity(
      id: customer.id,
      name: customer.name,
      phone: customer.phone,
      createdAt: customer.createdAt,
      updatedAt: DateTime.now(),
      syncStatus: isOnline ? SyncStatus.synced : SyncStatus.pendingUpdate,
    );

    await localDataSource.save(CustomerModel.fromEntity(updated));

    if (isOnline) {
      try {
        await remoteDataSource.upsertCustomer({
          'id': updated.id,
          'name': updated.name,
          'phone': updated.phone,
          'updated_at': updated.updatedAt.toIso8601String(),
        });
      } catch (e) {
        final pending = CustomerModel.fromEntity(updated)..syncStatus = SyncStatus.pendingUpdate;
        await localDataSource.save(pending);
      }
    }
  }

  @override
  Future<void> syncPendingCustomers() async {
    if (!isOnline) return;

    final pending = await localDataSource.getPendingSync();
    for (final model in pending) {
      try {
        final entity = model.toEntity();
        await remoteDataSource.upsertCustomer({
          'id': entity.id,
          'name': entity.name,
          'phone': entity.phone,
          // 'email': entity.email, // Removed as CustomerEntity does not have this field
          // 'address': entity.address, // Removed as CustomerEntity does not have this field
          'created_at': entity.createdAt.toIso8601String(),
          'updated_at': entity.updatedAt.toIso8601String(),
        });
        
        final synced = CustomerModel.fromEntity(entity)..syncStatus = SyncStatus.synced;
        await localDataSource.save(synced);
      } catch (e) {
        // Continue with others
      }
    }
  }
}
