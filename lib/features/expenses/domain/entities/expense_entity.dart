import '../../../../core/network/sync_status.dart';

class ExpenseEntity {
  final String id;
  final String category;
  final double amount;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;

  ExpenseEntity({
    required this.id,
    required this.category,
    required this.amount,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = SyncStatus.synced,
  });

  ExpenseEntity copyWith({
    String? id,
    String? category,
    double? amount,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return ExpenseEntity(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
