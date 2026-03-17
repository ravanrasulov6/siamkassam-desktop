import '../entities/sale_entity.dart';

abstract class SaleRepository {
  Future<List<SaleEntity>> getSales();
  Future<void> processSale(SaleEntity sale);
  Future<void> syncPendingSales();
}
