import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/supabase_provider.dart';
import '../../../../core/database/isar_provider.dart';
import '../../../../core/network/connectivity_provider.dart';
import '../../data/data_sources/product_local_data_source.dart';
import '../../data/data_sources/product_remote_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final productLocalDataSourceProvider = Provider<ProductLocalDataSource>((ref) {
  return ProductLocalDataSource(ref.watch(isarProvider));
});

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSource(ref.watch(supabaseClientProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return ProductRepositoryImpl(
    localDataSource: ref.watch(productLocalDataSourceProvider),
    remoteDataSource: ref.watch(productRemoteDataSourceProvider),
    isOnline: connectivity.value == NetworkStatus.online,
  );
});

class ProductListNotifier extends AsyncNotifier<List<ProductEntity>> {
  @override
  Future<List<ProductEntity>> build() async {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    if (user == null) return [];
    
    final businessId = user.businessId ?? user.id;
    return ref.watch(productRepositoryProvider).getProducts(businessId);
  }

  Future<void> refresh() async {
    final user = ref.read(authProvider).user;
    if (user == null) return;
    
    final businessId = user.businessId ?? user.id;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(productRepositoryProvider).getProducts(businessId));
  }
}

final productListProvider = AsyncNotifierProvider<ProductListNotifier, List<ProductEntity>>(() {
  return ProductListNotifier();
});
