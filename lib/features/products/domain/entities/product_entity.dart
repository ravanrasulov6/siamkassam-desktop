import '../../../../core/network/sync_status.dart';

class ProductEntity {
  final String id;
  final String name;
  final String? description;
  final double purchasePrice;
  final double salePrice;
  final int stockQuantity;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;

  ProductEntity({
    required this.id,
    required this.name,
    this.description,
    required this.purchasePrice,
    required this.salePrice,
    this.stockQuantity = 0,
    this.category,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = SyncStatus.synced,
  });
}
