import '../../domain/entities/debt_entity.dart';
import '../../domain/repositories/debt_repository.dart';
import '../data_sources/debt_local_data_source.dart';
import '../data_sources/debt_remote_data_source.dart';
import '../models/debt_model.dart';
import '../../../../core/network/sync_status.dart';
import 'package:uuid/uuid.dart';

class DebtRepositoryImpl implements DebtRepository {
  final DebtLocalDataSource localDataSource;
  final DebtRemoteDataSource remoteDataSource;
  final bool isOnline;

  DebtRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.isOnline,
  });

  @override
  Future<List<DebtEntity>> getDebts({DebtType? type}) async {
    final localModels = await localDataSource.getAll(type: type);
    final entities = localModels.map((m) => m.toEntity()).toList();

    if (isOnline) {
      _syncFromRemote();
    }

    return entities;
  }

  Future<void> _syncFromRemote() async {
    try {
      final remoteData = await remoteDataSource.fetchDebts();
      final remoteModels = remoteData.map((json) => DebtModel()
        ..id = json['id']
        ..customerId = json['customer_id']
        ..name = json['name']
        ..amount = (json['amount'] as num).toDouble()
        ..description = json['description']
        ..type = json['type'] == 'receivable' ? DebtType.receivable : DebtType.payable
        ..dueDate = DateTime.parse(json['due_date'])
        ..createdAt = DateTime.parse(json['created_at'])
        ..updatedAt = DateTime.parse(json['updated_at'])
        ..syncStatus = SyncStatus.synced
      ).toList();

      await localDataSource.saveAll(remoteModels);
    } catch (e) {
      // Handle error
    }
  }

  @override
  Future<void> addDebt(DebtEntity debt) async {
    final remoteId = const Uuid().v4();
    final newDebt = DebtEntity(
      id: remoteId,
      customerId: debt.customerId,
      name: debt.name,
      amount: debt.amount,
      description: debt.description,
      type: debt.type,
      dueDate: debt.dueDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      syncStatus: isOnline ? SyncStatus.synced : SyncStatus.pendingInsert,
    );

    await localDataSource.save(DebtModel.fromEntity(newDebt));

    if (isOnline) {
      try {
        await remoteDataSource.upsertDebt({
          'id': newDebt.id,
          'customer_id': newDebt.customerId,
          'name': newDebt.name,
          'amount': newDebt.amount,
          'description': newDebt.description,
          'type': newDebt.type.name,
          'due_date': newDebt.dueDate.toIso8601String(),
          'created_at': newDebt.createdAt.toIso8601String(),
          'updated_at': newDebt.updatedAt.toIso8601String(),
        });
      } catch (e) {
        final pending = DebtModel.fromEntity(newDebt)..syncStatus = SyncStatus.pendingInsert;
        await localDataSource.save(pending);
      }
    }
  }

  @override
  Future<void> updateDebt(DebtEntity debt) async {
    final updated = DebtEntity(
      id: debt.id,
      customerId: debt.customerId,
      name: debt.name,
      amount: debt.amount,
      description: debt.description,
      type: debt.type,
      dueDate: debt.dueDate,
      createdAt: debt.createdAt,
      updatedAt: DateTime.now(),
      syncStatus: isOnline ? SyncStatus.synced : SyncStatus.pendingUpdate,
    );

    await localDataSource.save(DebtModel.fromEntity(updated));

    if (isOnline) {
      try {
        await remoteDataSource.upsertDebt({
          'id': updated.id,
          'customer_id': updated.customerId,
          'name': updated.name,
          'amount': updated.amount,
          'description': updated.description,
          'type': updated.type.name,
          'due_date': updated.dueDate.toIso8601String(),
          'updated_at': updated.updatedAt.toIso8601String(),
        });
      } catch (e) {
        final pending = DebtModel.fromEntity(updated)..syncStatus = SyncStatus.pendingUpdate;
        await localDataSource.save(pending);
      }
    }
  }

  @override
  Future<void> deleteDebt(String id) async {
    await localDataSource.delete(id);
    if (isOnline) {
      try {
        await remoteDataSource.deleteDebt(id);
      } catch (e) {
        // Handle sync delete later
      }
    }
  }

  @override
  Future<void> syncPendingDebts() async {
    if (!isOnline) return;

    final pending = await localDataSource.getPendingSync();
    for (final model in pending) {
      try {
        final entity = model.toEntity();
        await remoteDataSource.upsertDebt({
          'id': entity.id,
          'customer_id': entity.customerId,
          'name': entity.name,
          'amount': entity.amount,
          'description': entity.description,
          'type': entity.type.name,
          'due_date': entity.dueDate.toIso8601String(),
          'created_at': entity.createdAt.toIso8601String(),
          'updated_at': entity.updatedAt.toIso8601String(),
        });

        final synced = DebtModel.fromEntity(entity)..syncStatus = SyncStatus.synced;
        await localDataSource.save(synced);
      } catch (e) {
        // Continue
      }
    }
  }
}

