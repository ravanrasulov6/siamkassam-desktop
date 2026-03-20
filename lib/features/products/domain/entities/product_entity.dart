import '../../../../core/network/sync_status.dart';

class ProductEntity {
  final String id;
  final String? businessId;
  final String name;
  final String? description;
  final String? sku;
  final String? barcode;
  final double purchasePrice;
  final double salePrice;
  final int stockQuantity;
  final int minStockThreshold;
  final String? unit;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;

  ProductEntity({
    required this.id,
    this.businessId,
    required this.name,
    this.description,
    this.sku,
    this.barcode,
    required this.purchasePrice,
    required this.salePrice,
    this.stockQuantity = 0,
    this.minStockThreshold = 5,
    this.unit = 'ədəd',
    this.category,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = SyncStatus.synced,
  });
}
