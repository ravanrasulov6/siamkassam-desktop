import 'package:uuid/uuid.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../data_sources/expense_local_data_source.dart';
import '../data_sources/expense_remote_data_source.dart';
import '../models/expense_model.dart';
import '../../../../core/network/sync_status.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;
  final ExpenseRemoteDataSource remoteDataSource;
  final bool isOnline;

  ExpenseRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.isOnline,
  });

  @override
  Future<List<ExpenseEntity>> getExpenses() async {
    final localModels = await localDataSource.getAll();
    final entities = localModels.map((m) => m.toEntity()).toList();

    if (isOnline) {
      _syncFromRemote();
    }

    return entities;
  }

  Future<void> _syncFromRemote() async {
    try {
      final remoteData = await remoteDataSource.fetchExpenses();
      final remoteModels = remoteData.map((json) => ExpenseModel()
        ..id = json['id']
        ..category = json['category']
        ..amount = (json['amount'] as num).toDouble()
        ..description = json['description'] ?? ''
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
  Future<void> addExpense(ExpenseEntity expense) async {
    final remoteId = const Uuid().v4();
    final newExpense = expense.copyWith(
      id: remoteId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      syncStatus: isOnline ? SyncStatus.synced : SyncStatus.pendingInsert,
    );

    await localDataSource.save(ExpenseModel.fromEntity(newExpense));

    if (isOnline) {
      try {
        await remoteDataSource.upsertExpense({
          'id': newExpense.id,
          'category': newExpense.category,
          'amount': newExpense.amount,
          'description': newExpense.description,
          'created_at': newExpense.createdAt.toIso8601String(),
          'updated_at': newExpense.updatedAt.toIso8601String(),
        });
      } catch (e) {
        final pending = ExpenseModel.fromEntity(newExpense)..syncStatus = SyncStatus.pendingInsert;
        await localDataSource.save(pending);
      }
    }
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) async {
    final updated = expense.copyWith(
      updatedAt: DateTime.now(),
      syncStatus: isOnline ? SyncStatus.synced : SyncStatus.pendingUpdate,
    );

    await localDataSource.save(ExpenseModel.fromEntity(updated));

    if (isOnline) {
      try {
        await remoteDataSource.upsertExpense({
          'id': updated.id,
          'category': updated.category,
          'amount': updated.amount,
          'description': updated.description,
          'updated_at': updated.updatedAt.toIso8601String(),
        });
      } catch (e) {
        final pending = ExpenseModel.fromEntity(updated)..syncStatus = SyncStatus.pendingUpdate;
        await localDataSource.save(pending);
      }
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    await localDataSource.delete(id);
    if (isOnline) {
      try {
        await remoteDataSource.deleteExpense(id);
      } catch (e) {
        // Handle sync delete later
      }
    }
  }

  @override
  Future<void> syncPendingExpenses() async {
    if (!isOnline) return;

    final pending = await localDataSource.getPendingSync();
    for (final model in pending) {
      try {
        final entity = model.toEntity();
        await remoteDataSource.upsertExpense({
          'id': entity.id,
          'category': entity.category,
          'amount': entity.amount,
          'description': entity.description,
          'created_at': entity.createdAt.toIso8601String(),
          'updated_at': entity.updatedAt.toIso8601String(),
        });

        final synced = ExpenseModel.fromEntity(entity)..syncStatus = SyncStatus.synced;
        await localDataSource.save(synced);
      } catch (e) {
        // Continue
      }
    }
  }
}
