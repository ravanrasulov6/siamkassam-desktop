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
    print('SyncEngine: Synchronization started...');
    
    try {
      await _syncEntity('Customers', ref.read(customerRepositoryProvider).syncPendingCustomers());
      await _syncEntity('Products', ref.read(productRepositoryProvider).syncPendingProducts());
      await _syncEntity('Debts', ref.read(debtRepositoryProvider).syncPendingDebts());
      await _syncEntity('Sales', ref.read(saleRepositoryProvider).syncPendingSales());
      
      print('SyncEngine: Synchronization completed successfully.');
    } catch (e) {
      print('SyncEngine: Global synchronization error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _syncEntity(String name, Future<void> syncFuture) async {
    try {
      await syncFuture;
      print('SyncEngine: $name synced successfully.');
    } catch (e) {
      print('SyncEngine: Error syncing $name: $e');
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
