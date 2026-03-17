import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/customers/presentation/providers/customer_provider.dart';
import '../../features/products/presentation/providers/product_provider.dart';
import '../../features/debts/presentation/providers/debt_provider.dart';
import '../../features/pos/presentation/providers/sale_provider.dart';
import '../network/connectivity_provider.dart';

class SyncEngine {
  final Ref ref;
  Timer? _syncTimer;
  bool _isSyncing = false;

  SyncEngine(this.ref) {
    _init();
  }

  void _init() {
    // Listen for connectivity changes
    ref.listen(connectivityProvider, (previous, next) {
      if (next.value == NetworkStatus.online) {
        syncNow();
      }
    });

    // periodic sync every 5 minutes
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) => syncNow());
  }

  Future<void> syncNow() async {
    if (_isSyncing) return;
    
    final status = ref.read(connectivityProvider).value;
    if (status != NetworkStatus.online) return;

    _isSyncing = true;
    try {
      await Future.wait<void>([
        ref.read(customerRepositoryProvider).syncPendingCustomers(),
        ref.read(productRepositoryProvider).syncPendingProducts(),
        ref.read(debtRepositoryProvider).syncPendingDebts(),
        ref.read(saleRepositoryProvider).syncPendingSales(),
      ]);
    } catch (e) {
      // Log sync error
    } finally {
      _isSyncing = false;
    }
  }

  void dispose() {
    _syncTimer?.cancel();
  }
}

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final engine = SyncEngine(ref);
  ref.onDispose(() => engine.dispose());
  return engine;
});
