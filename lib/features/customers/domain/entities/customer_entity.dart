import '../../../../core/network/sync_status.dart';

class CustomerEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? email;
  final double creditLimit;
  final double totalDebt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;

  CustomerEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.email,
    this.creditLimit = 0,
    this.totalDebt = 0,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = SyncStatus.synced,
  });

  String get fullName => '$firstName $lastName'.trim();
}
