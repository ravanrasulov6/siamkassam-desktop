import '../entities/debt_entity.dart';

abstract class DebtRepository {
  Future<List<DebtEntity>> getDebts({DebtType? type});
  Future<void> addDebt(DebtEntity debt);
  Future<void> updateDebt(DebtEntity debt);
  Future<void> deleteDebt(String id);
  Future<void> syncPendingDebts();
}
