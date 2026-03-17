import '../../../../core/network/sync_status.dart';

class CustomerEntity {
  final String id;
  final String name;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;

  CustomerEntity({
    required this.id,
    required this.name,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = SyncStatus.synced,
  });
}
