import 'package:isar/isar.dart';
import '../../../../core/network/sync_status.dart';
import '../../domain/entities/expense_entity.dart';

part 'expense_model.g.dart';

@collection
class ExpenseModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;
  
  late String category;
  late double amount;
  late String description;
  late DateTime createdAt;
  late DateTime updatedAt;

  @enumerated
  late SyncStatus syncStatus;

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      category: category,
      amount: amount,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
    );
  }

  static ExpenseModel fromEntity(ExpenseEntity entity) {
    return ExpenseModel()
      ..id = entity.id
      ..category = entity.category
      ..amount = entity.amount
      ..description = entity.description
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..syncStatus = entity.syncStatus;
  }
}
