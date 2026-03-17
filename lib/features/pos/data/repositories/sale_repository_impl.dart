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
  Future<List<SaleEntity>> getSales() async {
    final localModels = await localDataSource.getAll();
    final entities = localModels.map((m) => m.toEntity()).toList();

    if (isOnline) {
      _syncFromRemote();
    }

    return entities;
  }

  Future<void> _syncFromRemote() async {
    try {
      final remoteData = await remoteDataSource.fetchSales();
      final remoteModels = remoteData.map((json) {
        final itemsJson = json['sale_items'] as List;
        return SaleModel()
          ..id = json['id']
          ..customerId = json['customer_id']
          ..customerName = json['customer_name']
          ..items = itemsJson.map((i) => SaleItemModel()
            ..id = i['id']
            ..productId = i['product_id']
            ..productName = i['product_name']
            ..quantity = (i['quantity'] as num).toDouble()
            ..price = (i['price'] as num).toDouble()
            ..total = (i['total'] as num).toDouble()
          ).toList()
          ..subtotal = (json['subtotal'] as num).toDouble()
          ..discount = (json['discount'] as num).toDouble()
          ..total = (json['total'] as num).toDouble()
          ..paymentMethod = json['payment_method']
          ..createdAt = DateTime.parse(json['created_at'])
          ..syncStatus = SyncStatus.synced;
      }).toList();

      await localDataSource.saveAll(remoteModels);
    } catch (e) {
      // Handle error
    }
  }

  @override
  Future<void> processSale(SaleEntity sale) async {
    final saleId = const Uuid().v4();
    final newSale = SaleEntity(
      id: saleId,
      customerId: sale.customerId,
      customerName: sale.customerName,
      items: sale.items.map((i) => SaleItemEntity(
        id: const Uuid().v4(),
        productId: i.productId,
        productName: i.productName,
        quantity: i.quantity,
        price: i.price,
        total: i.total,
      )).toList(),
      subtotal: sale.subtotal,
      discount: sale.discount,
      total: sale.total,
      paymentMethod: sale.paymentMethod,
      createdAt: DateTime.now(),
      syncStatus: isOnline ? SyncStatus.synced : SyncStatus.pendingInsert,
    );

    await localDataSource.save(SaleModel.fromEntity(newSale));

    if (isOnline) {
      try {
        await remoteDataSource.createSale({
          'id': newSale.id,
          'customer_id': newSale.customerId,
          'customer_name': newSale.customerName,
          'subtotal': newSale.subtotal,
          'discount': newSale.discount,
          'total': newSale.total,
          'payment_method': newSale.paymentMethod,
          'created_at': newSale.createdAt.toIso8601String(),
        });

        final itemsData = newSale.items.map((i) => {
          'id': i.id,
          'sale_id': newSale.id,
          'product_id': i.productId,
          'product_name': i.productName,
          'quantity': i.quantity,
          'price': i.price,
          'total': i.total,
        }).toList();

        await remoteDataSource.createSaleItems(itemsData);
      } catch (e) {
        final pending = SaleModel.fromEntity(newSale)..syncStatus = SyncStatus.pendingInsert;
        await localDataSource.save(pending);
      }
    }
  }

  @override
  Future<void> syncPendingSales() async {
    if (!isOnline) return;

    final pending = await localDataSource.getPendingSync();
    for (final model in pending) {
      try {
        final entity = model.toEntity();
        
        // Push sale
        await remoteDataSource.createSale({
          'id': entity.id,
          'customer_id': entity.customerId,
          'customer_name': entity.customerName,
          'subtotal': entity.subtotal,
          'discount': entity.discount,
          'total': entity.total,
          'payment_method': entity.paymentMethod,
          'created_at': entity.createdAt.toIso8601String(),
        });

        // Push sale items
        final itemsData = entity.items.map((i) => {
          'id': i.id,
          'sale_id': entity.id,
          'product_id': i.productId,
          'product_name': i.productName,
          'quantity': i.quantity,
          'price': i.price,
          'total': i.total,
        }).toList();

        await remoteDataSource.createSaleItems(itemsData);

        final synced = SaleModel.fromEntity(entity)..syncStatus = SyncStatus.synced;
        await localDataSource.save(synced);
      } catch (e) {
        // Continue
      }
    }
  }
}

