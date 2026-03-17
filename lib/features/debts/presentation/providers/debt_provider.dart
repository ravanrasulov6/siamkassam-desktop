import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/supabase_provider.dart';
import '../../../../core/database/isar_provider.dart';
import '../../../../core/network/connectivity_provider.dart';
import '../../data/data_sources/debt_local_data_source.dart';
import '../../data/data_sources/debt_remote_data_source.dart';
import '../../data/repositories/debt_repository_impl.dart';
import '../../domain/entities/debt_entity.dart';
import '../../domain/repositories/debt_repository.dart';

final debtLocalDataSourceProvider = Provider<DebtLocalDataSource>((ref) {
  return DebtLocalDataSource(ref.watch(isarProvider));
});

final debtRemoteDataSourceProvider = Provider<DebtRemoteDataSource>((ref) {
  return DebtRemoteDataSource(ref.watch(supabaseClientProvider));
});

final debtRepositoryProvider = Provider<DebtRepository>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return DebtRepositoryImpl(
    localDataSource: ref.watch(debtLocalDataSourceProvider),
    remoteDataSource: ref.watch(debtRemoteDataSourceProvider),
    isOnline: connectivity.value == NetworkStatus.online,
  );
});

class DebtListNotifier extends AsyncNotifier<List<DebtEntity>> {
  @override
  Future<List<DebtEntity>> build() async {
    return ref.watch(debtRepositoryProvider).getDebts();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(debtRepositoryProvider).getDebts());
  }
}

final debtListProvider = AsyncNotifierProvider<DebtListNotifier, List<DebtEntity>>(() {
  return DebtListNotifier();
});

// Providers for specific debt types
final receivablesProvider = Provider<AsyncValue<List<DebtEntity>>>((ref) {
  return ref.watch(debtListProvider).whenData(
    (debts) => debts.where((d) => d.type == DebtType.receivable).toList(),
  );
});

final payablesProvider = Provider<AsyncValue<List<DebtEntity>>>((ref) {
  return ref.watch(debtListProvider).whenData(
    (debts) => debts.where((d) => d.type == DebtType.payable).toList(),
  );
});
