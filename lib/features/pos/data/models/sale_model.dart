import 'package:isar/isar.dart';
import '../../domain/entities/sale_entity.dart';
import '../../../../core/network/sync_status.dart';

part 'sale_model.g.dart';

@collection
class SaleModel {
  Id? localId;

  @Index(unique: true, replace: true)
  late String id;
  
  @Index()
  late String businessId;
  
  String? customerId;
  String? customerName;
  
  late List<SaleItemModel> items;
  
  late double subtotal;
  late double discount;
  late double total;
  late String paymentMethod;
  late DateTime createdAt;

  @enumerated
  late SyncStatus syncStatus;

  SaleEntity toEntity() {
    return SaleEntity(
      id: id,
      businessId: businessId,
      customerId: customerId,
      customerName: customerName,
      items: items.map((i) => i.toEntity()).toList(),
      subtotal: subtotal,
      discount: discount,
      total: total,
      paymentMethod: paymentMethod,
      createdAt: createdAt,
      syncStatus: syncStatus,
    );
  }

  static SaleModel fromEntity(SaleEntity entity, {String? businessId}) {
    return SaleModel()
      ..id = entity.id
      ..businessId = businessId ?? entity.businessId ?? ''
      ..customerId = entity.customerId
      ..customerName = entity.customerName
      ..items = entity.items.map((i) => SaleItemModel.fromEntity(i)).toList()
      ..subtotal = entity.subtotal
      ..discount = entity.discount
      ..total = entity.total
      ..paymentMethod = entity.paymentMethod
      ..createdAt = entity.createdAt
      ..syncStatus = entity.syncStatus;
  }
}

@embedded
class SaleItemModel {
  late String id;
  late String saleId;
  late String productId;
  late String productName;
  late double quantity;
  late double price;
  late double total;

  SaleItemEntity toEntity() {
    return SaleItemEntity(
      id: id,
      saleId: saleId,
      productId: productId,
      productName: productName,
      quantity: quantity,
      price: price,
      total: total,
    );
  }

  static SaleItemModel fromEntity(SaleItemEntity entity) {
    return SaleItemModel()
      ..id = entity.id
      ..saleId = entity.saleId
      ..productId = entity.productId
      ..productName = entity.productName
      ..quantity = entity.quantity
      ..price = entity.price
      ..total = entity.total;
  }
}
