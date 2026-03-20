import '../../domain/entities/sale_entity.dart';
import '../../domain/repositories/sale_repository.dart';
import '../data_sources/sale_local_data_source.dart';
import '../data_sources/sale_remote_data_source.dart';
import '../models/sale_model.dart';
import '../../../../core/network/sync_status.dart';
import 'package:uuid/uuid.dart';

class SaleRepositoryImpl implements SaleRepository {
  final SaleLocalDataSource localDataSource;
  final SaleRemoteDataSource remoteDataSource;
  final bool isOnline;

  SaleRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.isOnline,
  });

  @override
  Future<List<SaleEntity>> getSales(String businessId) async {
    final localModels = await localDataSource.getAll();
    final entities = localModels.map((m) => m.toEntity()).toList();

    if (isOnline) {
      _syncFromRemote(businessId);
    }

    return entities;
  }

  Future<void> _syncFromRemote(String businessId) async {
    try {
      final remoteData = await remoteDataSource.fetchSales(businessId);
      final remoteModels = remoteData.map((json) {
        final itemsJson = json['sale_items'] as List? ?? [];
        return SaleModel()
          ..id = json['id']
          ..businessId = businessId
          ..customerId = json['customer_id']
          ..customerName = json['customer_name']
          ..items = itemsJson.map((i) {
            final item = SaleItemModel()
              ..id = i['id']
              ..saleId = json['id']
              ..productId = i['product_id']
              ..productName = i['product_name'] ?? ''
              ..quantity = (i['quantity'] as num).toDouble()
              ..price = (i['price'] as num).toDouble()
              ..total = (i['total'] as num).toDouble();
            return item;
          }).toList()
          ..subtotal = (json['subtotal'] as num).toDouble()
          ..discount = (json['discount'] as num).toDouble()
          ..total = (json['total'] as num).toDouble()
          ..paymentMethod = json['payment_method'] ?? 'cash'
          ..createdAt = DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String())
          ..syncStatus = SyncStatus.synced;
      }).toList();

      await localDataSource.saveAll(remoteModels);
    } catch (e) {
      // Handle error
    }
  }

  @override
  Future<void> processSale(SaleEntity sale) async {
    final saleId = sale.id.isEmpty ? const Uuid().v4() : sale.id;
    final model = SaleModel.fromEntity(sale)
      ..id = saleId
      ..syncStatus = isOnline ? SyncStatus.synced : SyncStatus.pendingInsert;

    await localDataSource.save(model);

    if (isOnline) {
      try {
        await remoteDataSource.createSale({
          'id': model.id,
          'business_id': model.businessId,
          'customer_id': model.customerId,
          'customer_name': model.customerName,
          'subtotal': model.subtotal,
          'discount': model.discount,
          'total': model.total,
          'payment_method': model.paymentMethod,
          'created_at': model.createdAt.toIso8601String(),
        });

        final itemsData = model.items.map((i) => {
          'id': i.id,
          'sale_id': model.id,
          'product_id': i.productId,
          'product_name': i.productName,
          'quantity': i.quantity,
          'price': i.price,
          'total': i.total,
        }).toList();

        await remoteDataSource.createSaleItems(itemsData);
      } catch (e) {
        model.syncStatus = SyncStatus.pendingInsert;
        await localDataSource.save(model);
      }
    }
  }

  @override
  Future<void> syncPendingSales() async {
    if (!isOnline) return;
    final pending = await localDataSource.getPendingSync();
    for (final model in pending) {
      try {
        await remoteDataSource.createSale({
          'id': model.id,
          'business_id': model.businessId,
          'customer_id': model.customerId,
          'customer_name': model.customerName,
          'subtotal': model.subtotal,
          'discount': model.discount,
          'total': model.total,
          'payment_method': model.paymentMethod,
          'created_at': model.createdAt.toIso8601String(),
        });

        final itemsData = model.items.map((i) => {
          'id': i.id,
          'sale_id': model.id,
          'product_id': i.productId,
          'product_name': i.productName,
          'quantity': i.quantity,
          'price': i.price,
          'total': i.total,
        }).toList();

        await remoteDataSource.createSaleItems(itemsData);

        model.syncStatus = SyncStatus.synced;
        await localDataSource.save(model);
      } catch (e) {}
    }
  }
}
