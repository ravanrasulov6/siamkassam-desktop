import '../../../../core/network/sync_status.dart';

enum DebtType { receivable, payable }

class DebtEntity {
  final String id;
  final String? customerId; // Null for payables to suppliers (optional)
  final String name; // Person or Supplier name
  final double amount;
  final String? description;
  final DebtType type;
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;

  DebtEntity({
    required this.id,
    this.customerId,
    required this.name,
    required this.amount,
    this.description,
    required this.type,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = SyncStatus.synced,
  });
}
