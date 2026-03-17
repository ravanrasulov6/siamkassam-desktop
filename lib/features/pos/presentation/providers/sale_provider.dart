import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/supabase_provider.dart';
import '../../../../core/database/isar_provider.dart';
import '../../../../core/network/connectivity_provider.dart';
import '../../data/data_sources/sale_local_data_source.dart';
import '../../data/data_sources/sale_remote_data_source.dart';
import '../../data/repositories/sale_repository_impl.dart';
import '../../domain/entities/sale_entity.dart';
import '../../domain/repositories/sale_repository.dart';

final saleLocalDataSourceProvider = Provider<SaleLocalDataSource>((ref) {
  return SaleLocalDataSource(ref.watch(isarProvider));
});

final saleRemoteDataSourceProvider = Provider<SaleRemoteDataSource>((ref) {
  return SaleRemoteDataSource(ref.watch(supabaseClientProvider));
});

final saleRepositoryProvider = Provider<SaleRepository>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return SaleRepositoryImpl(
    localDataSource: ref.watch(saleLocalDataSourceProvider),
    remoteDataSource: ref.watch(saleRemoteDataSourceProvider),
    isOnline: connectivity.value == NetworkStatus.online,
  );
});

class SaleListNotifier extends AsyncNotifier<List<SaleEntity>> {
  @override
  Future<List<SaleEntity>> build() async {
    return ref.watch(saleRepositoryProvider).getSales();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(saleRepositoryProvider).getSales());
  }
}

final saleListProvider = AsyncNotifierProvider<SaleListNotifier, List<SaleEntity>>(() {
  return SaleListNotifier();
});

// POS Cart Provider
final cartProvider = StateProvider<List<SaleItemEntity>>((ref) => []);
