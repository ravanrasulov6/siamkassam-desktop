import 'package:isar/isar.dart';
import '../../domain/entities/customer_entity.dart';
import '../../../../core/network/sync_status.dart';

part 'customer_model.g.dart';

@collection
class CustomerModel {
  Id? localId; // Isar auto-increment ID

  @Index(unique: true, replace: true)
  late String id; // Remote UUID
  
  late String name;
  String? phone;
  late DateTime createdAt;
  late DateTime updatedAt;

  @enumerated
  late SyncStatus syncStatus;

  CustomerEntity toEntity() {
    return CustomerEntity(
      id: id,
      name: name,
      phone: phone,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
    );
  }

  static CustomerModel fromEntity(CustomerEntity entity) {
    return CustomerModel()
      ..id = entity.id
      ..name = entity.name
      ..phone = entity.phone
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..syncStatus = entity.syncStatus;
  }
}
