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
  Future<List<ProductEntity>> getProducts() async {
    final localModels = await localDataSource.getAll();
    final entities = localModels.map((m) => m.toEntity()).toList();

    if (isOnline) {
      _syncFromRemote();
    }

    return entities;
  }

  Future<void> _syncFromRemote() async {
    try {
      final remoteData = await remoteDataSource.fetchProducts();
      final remoteModels = remoteData.map((json) => ProductModel()
        ..id = json['id']
        ..name = json['name']
        ..description = json['description']
        ..purchasePrice = (json['purchase_price'] as num).toDouble()
        ..salePrice = (json['sale_price'] as num).toDouble()
        ..stockQuantity = json['stock_quantity'] as int
        ..category = json['category']
        ..createdAt = DateTime.parse(json['created_at'])
        ..updatedAt = DateTime.parse(json['updated_at'])
        ..syncStatus = SyncStatus.synced
      ).toList();

      await localDataSource.saveAll(remoteModels);
    } catch (e) {
      // Handle error
    }
  }

  @override
  Future<void> addProduct(ProductEntity product) async {
    final remoteId = const Uuid().v4();
    final newProduct = ProductEntity(
      id: remoteId,
      name: product.name,
      description: product.description,
      purchasePrice: product.purchasePrice,
      salePrice: product.salePrice,
      stockQuantity: product.stockQuantity,
      category: product.category,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      syncStatus: isOnline ? SyncStatus.synced : SyncStatus.pendingInsert,
    );

    await localDataSource.save(ProductModel.fromEntity(newProduct));

    if (isOnline) {
      try {
        await remoteDataSource.upsertProduct({
          'id': newProduct.id,
          'name': newProduct.name,
          'description': newProduct.description,
          'purchase_price': newProduct.purchasePrice,
          'sale_price': newProduct.salePrice,
          'stock_quantity': newProduct.stockQuantity,
          'category': newProduct.category,
          'created_at': newProduct.createdAt.toIso8601String(),
          'updated_at': newProduct.updatedAt.toIso8601String(),
        });
      } catch (e) {
        final pending = ProductModel.fromEntity(newProduct)..syncStatus = SyncStatus.pendingInsert;
        await localDataSource.save(pending);
      }
    }
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    final updated = ProductEntity(
      id: product.id,
      name: product.name,
      description: product.description,
      purchasePrice: product.purchasePrice,
      salePrice: product.salePrice,
      stockQuantity: product.stockQuantity,
      category: product.category,
      createdAt: product.createdAt,
      updatedAt: DateTime.now(),
      syncStatus: isOnline ? SyncStatus.synced : SyncStatus.pendingUpdate,
    );

    await localDataSource.save(ProductModel.fromEntity(updated));

    if (isOnline) {
      try {
        await remoteDataSource.upsertProduct({
          'id': updated.id,
          'name': updated.name,
          'description': updated.description,
          'purchase_price': updated.purchasePrice,
          'sale_price': updated.salePrice,
          'stock_quantity': updated.stockQuantity,
          'category': updated.category,
          'updated_at': updated.updatedAt.toIso8601String(),
        });
      } catch (e) {
        final pending = ProductModel.fromEntity(updated)..syncStatus = SyncStatus.pendingUpdate;
        await localDataSource.save(pending);
      }
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    await localDataSource.delete(id);
    if (isOnline) {
      try {
        await remoteDataSource.deleteProduct(id);
      } catch (e) {
        // Handle sync delete later or mark as pending delete
      }
    }
  }

  @override
  Future<void> syncPendingProducts() async {
    if (!isOnline) return;

    final pending = await localDataSource.getPendingSync();
    for (final model in pending) {
      try {
        final entity = model.toEntity();
        await remoteDataSource.upsertProduct({
          'id': entity.id,
          'name': entity.name,
          'description': entity.description,
          'purchase_price': entity.purchasePrice,
          'sale_price': entity.salePrice,
          'stock_quantity': entity.stockQuantity,
          'category': entity.category,
          'created_at': entity.createdAt.toIso8601String(),
          'updated_at': entity.updatedAt.toIso8601String(),
        });

        final synced = ProductModel.fromEntity(entity)..syncStatus = SyncStatus.synced;
        await localDataSource.save(synced);
      } catch (e) {
        // Continue
      }
    }
  }
}

