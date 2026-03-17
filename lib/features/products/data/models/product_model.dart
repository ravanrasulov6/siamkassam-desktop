import 'package:isar/isar.dart';
import '../../domain/entities/product_entity.dart';
import '../../../../core/network/sync_status.dart';

part 'product_model.g.dart';

@collection
class ProductModel {
  Id? localId;

  @Index(unique: true, replace: true)
  late String id;
  
  late String name;
  String? description;
  late double purchasePrice;
  late double salePrice;
  late int stockQuantity;
  String? category;
  late DateTime createdAt;
  late DateTime updatedAt;

  @enumerated
  late SyncStatus syncStatus;

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      purchasePrice: purchasePrice,
      salePrice: salePrice,
      stockQuantity: stockQuantity,
      category: category,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
    );
  }

  static ProductModel fromEntity(ProductEntity entity) {
    return ProductModel()
      ..id = entity.id
      ..name = entity.name
      ..description = entity.description
      ..purchasePrice = entity.purchasePrice
      ..salePrice = entity.salePrice
      ..stockQuantity = entity.stockQuantity
      ..category = entity.category
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..syncStatus = entity.syncStatus;
  }
}
