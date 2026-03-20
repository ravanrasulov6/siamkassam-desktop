import 'package:isar/isar.dart';
import '../../domain/entities/product_entity.dart';
import '../../../../core/network/sync_status.dart';

part 'product_model.g.dart';

@collection
class ProductModel {
  Id? localId; // Isar auto-increment ID

  @Index(unique: true, replace: true)
  late String id; // Remote UUID
  
  @Index()
  late String businessId;
  
  late String name;
  String? description;
  String? sku;
  String? barcode;
  late double purchasePrice;
  late double salePrice;
  late int stockQuantity;
  late int minStockThreshold;
  String? unit;
  String? category;
  
  late DateTime createdAt;
  late DateTime updatedAt;

  @enumerated
  late SyncStatus syncStatus;

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      businessId: businessId,
      name: name,
      description: description,
      sku: sku,
      barcode: barcode,
      purchasePrice: purchasePrice,
      salePrice: salePrice,
      stockQuantity: stockQuantity,
      minStockThreshold: minStockThreshold,
      unit: unit,
      category: category,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
    );
  }

  static ProductModel fromEntity(ProductEntity entity, {String? businessId}) {
    return ProductModel()
      ..id = entity.id
      ..businessId = businessId ?? entity.businessId ?? ''
      ..name = entity.name
      ..description = entity.description
      ..sku = entity.sku
      ..barcode = entity.barcode
      ..purchasePrice = entity.purchasePrice
      ..salePrice = entity.salePrice
      ..stockQuantity = entity.stockQuantity
      ..minStockThreshold = entity.minStockThreshold
      ..unit = entity.unit
      ..category = entity.category
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..syncStatus = entity.syncStatus;
  }
}
