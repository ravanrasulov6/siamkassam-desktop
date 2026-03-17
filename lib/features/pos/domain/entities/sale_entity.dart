import '../../../../core/network/sync_status.dart';

class SaleItemEntity {
  final String id;
  final String productId;
  final String productName;
  final double quantity;
  final double price;
  final double total;

   SaleItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.total,
  });
}

class SaleEntity {
  final String id;
  final String? customerId;
  final String? customerName;
  final List<SaleItemEntity> items;
  final double subtotal;
  final double discount;
  final double total;
  final String paymentMethod;
  final DateTime createdAt;
  final SyncStatus syncStatus;

  SaleEntity({
    required this.id,
    this.customerId,
    this.customerName,
    required this.items,
    required this.subtotal,
    this.discount = 0.0,
    required this.total,
    required this.paymentMethod,
    required this.createdAt,
    this.syncStatus = SyncStatus.synced,
  });
}
