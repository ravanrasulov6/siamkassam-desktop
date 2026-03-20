import '../entities/sale_entity.dart';

abstract class SaleRepository {
  Future<List<SaleEntity>> getSales(String businessId);
  Future<void> processSale(SaleEntity sale);
  Future<void> syncPendingSales();
}
