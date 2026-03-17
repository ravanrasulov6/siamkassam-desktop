import 'package:isar/isar.dart';
import '../../domain/entities/debt_entity.dart';
import '../../../../core/network/sync_status.dart';

part 'debt_model.g.dart';

@collection
class DebtModel {
  Id? localId;

  @Index(unique: true, replace: true)
  late String id;
  
  String? customerId;
  late String name;
  late double amount;
  String? description;
  
  @enumerated
  late DebtType type;
  
  late DateTime dueDate;
  late DateTime createdAt;
  late DateTime updatedAt;

  @enumerated
  late SyncStatus syncStatus;

  DebtEntity toEntity() {
    return DebtEntity(
      id: id,
      customerId: customerId,
      name: name,
      amount: amount,
      description: description,
      type: type,
      dueDate: dueDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
    );
  }

  static DebtModel fromEntity(DebtEntity entity) {
    return DebtModel()
      ..id = entity.id
      ..customerId = entity.customerId
      ..name = entity.name
      ..amount = entity.amount
      ..description = entity.description
      ..type = entity.type
      ..dueDate = entity.dueDate
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..syncStatus = entity.syncStatus;
  }
}
