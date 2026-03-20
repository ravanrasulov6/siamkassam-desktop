import 'package:isar/isar.dart';
import '../../domain/entities/customer_entity.dart';
import '../../../../core/network/sync_status.dart';

part 'customer_model.g.dart';

@collection
class CustomerModel {
  Id? localId; // Isar auto-increment ID

  @Index(unique: true, replace: true)
  late String id; // Remote UUID
  
  @Index()
  late String businessId;
  
  late String firstName;
  late String lastName;
  String? phone;
  String? email;
  late double creditLimit;
  late double totalDebt;
  
  late DateTime createdAt;
  late DateTime updatedAt;

  @enumerated
  late SyncStatus syncStatus;

  CustomerEntity toEntity() {
    return CustomerEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      creditLimit: creditLimit,
      totalDebt: totalDebt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
    );
  }

  static CustomerModel fromEntity(CustomerEntity entity, {String? businessId}) {
    return CustomerModel()
      ..id = entity.id
      ..businessId = businessId ?? ''
      ..firstName = entity.firstName
      ..lastName = entity.lastName
      ..phone = entity.phone
      ..email = entity.email
      ..creditLimit = entity.creditLimit
      ..totalDebt = entity.totalDebt
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..syncStatus = entity.syncStatus;
  }
}
