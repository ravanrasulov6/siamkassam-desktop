import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../data_sources/product_local_data_source.dart';
import '../data_sources/product_remote_data_source.dart';
import '../models/product_model.dart';
import '../../../../core/network/sync_status.dart';
import 'package:uuid/uuid.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;
  final ProductRemoteDataSource remoteDataSource;
  final bool isOnline;

  ProductRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.isOnline,
  });

  @override
  Future<List<ProductEntity>> getProducts(String businessId) async {
    final localModels = await localDataSource.getAll();
    final entities = localModels.map((m) => m.toEntity()).toList();

    if (isOnline) {
      _syncFromRemote(businessId);
    }

    return entities;
  }

  Future<void> _syncFromRemote(String businessId) async {
    try {
      final remoteData = await remoteDataSource.fetchProducts(businessId);
      final remoteModels = remoteData.map((json) => ProductModel()
        ..id = json['id']
        ..businessId = businessId
        ..name = json['name'] ?? ''
        ..description = json['description']
        ..sku = json['sku']
        ..barcode = json['barcode']
        ..purchasePrice = (json['purchase_price'] as num?)?.toDouble() ?? 0
        ..salePrice = (json['sale_price'] as num?)?.toDouble() ?? 0
        ..stockQuantity = (json['stock_quantity'] as num?)?.toInt() ?? 0
        ..minStockThreshold = (json['min_stock_threshold'] as num?)?.toInt() ?? 5
        ..unit = json['unit'] ?? 'ədəd'
        ..category = json['category']
        ..createdAt = DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String())
        ..updatedAt = DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String())
        ..syncStatus = SyncStatus.synced
      ).toList();

      await localDataSource.saveAll(remoteModels);
    } catch (e) {
      // Handle error
    }
  }

  @override
  Future<void> addProduct(ProductEntity product) async {
    final model = ProductModel.fromEntity(product)
      ..id = product.id.isEmpty ? const Uuid().v4() : product.id
      ..syncStatus = isOnline ? SyncStatus.synced : SyncStatus.pendingInsert;

    await localDataSource.save(model);

    if (isOnline) {
      try {
        await remoteDataSource.upsertProduct({
          'id': model.id,
          'business_id': model.businessId,
          'name': model.name,
          'description': model.description,
          'sku': model.sku,
          'barcode': model.barcode,
          'purchase_price': model.purchasePrice,
          'sale_price': model.salePrice,
          'stock_quantity': model.stockQuantity,
          'min_stock_threshold': model.minStockThreshold,
          'unit': model.unit,
          'category': model.category,
          'created_at': model.createdAt.toIso8601String(),
          'updated_at': model.updatedAt.toIso8601String(),
        });
      } catch (e) {
        model.syncStatus = SyncStatus.pendingInsert;
        await localDataSource.save(model);
      }
    }
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    final model = ProductModel.fromEntity(product)
      ..updatedAt = DateTime.now()
      ..syncStatus = isOnline ? SyncStatus.synced : SyncStatus.pendingUpdate;

    await localDataSource.save(model);

    if (isOnline) {
      try {
        await remoteDataSource.upsertProduct({
          'id': model.id,
          'name': model.name,
          'description': model.description,
          'sku': model.sku,
          'barcode': model.barcode,
          'purchase_price': model.purchasePrice,
          'sale_price': model.salePrice,
          'stock_quantity': model.stockQuantity,
          'min_stock_threshold': model.minStockThreshold,
          'unit': model.unit,
          'category': model.category,
          'updated_at': model.updatedAt.toIso8601String(),
        });
      } catch (e) {
        model.syncStatus = SyncStatus.pendingUpdate;
        await localDataSource.save(model);
      }
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    await localDataSource.delete(id);
    if (isOnline) {
      try {
        await remoteDataSource.deleteProduct(id);
      } catch (e) {}
    }
  }

  @override
  Future<void> syncPendingProducts() async {
    if (!isOnline) return;
    final pending = await localDataSource.getPendingSync();
    for (final model in pending) {
      try {
        await remoteDataSource.upsertProduct({
          'id': model.id,
          'business_id': model.businessId,
          'name': model.name,
          'description': model.description,
          'sku': model.sku,
          'barcode': model.barcode,
          'purchase_price': model.purchasePrice,
          'sale_price': model.salePrice,
          'stock_quantity': model.stockQuantity,
          'min_stock_threshold': model.minStockThreshold,
          'unit': model.unit,
          'category': model.category,
          'updated_at': model.updatedAt.toIso8601String(),
        });
        model.syncStatus = SyncStatus.synced;
        await localDataSource.save(model);
      } catch (e) {}
    }
  }
}
