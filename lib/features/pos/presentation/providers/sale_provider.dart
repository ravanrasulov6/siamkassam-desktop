import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/supabase_provider.dart';
import '../../../../core/database/isar_provider.dart';
import '../../../../core/network/connectivity_provider.dart';
import '../../data/data_sources/sale_local_data_source.dart';
import '../../data/data_sources/sale_remote_data_source.dart';
import '../../data/repositories/sale_repository_impl.dart';
import '../../domain/entities/sale_entity.dart';
import '../../domain/repositories/sale_repository.dart';
import '../../../products/domain/repositories/product_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

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
    final user = ref.watch(authProvider).user;
    if (user == null) return [];
    final businessId = user.businessId ?? user.id;
    return ref.watch(saleRepositoryProvider).getSales(businessId);
  }

  Future<void> refresh() async {
    final user = ref.read(authProvider).user;
    if (user == null) return;
    final businessId = user.businessId ?? user.id;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(saleRepositoryProvider).getSales(businessId));
  }
}

final saleListProvider = AsyncNotifierProvider<SaleListNotifier, List<SaleEntity>>(() {
  return SaleListNotifier();
});

// POS Cart Notifier
class CartNotifier extends StateNotifier<List<SaleItemEntity>> {
  CartNotifier() : super([]);

  void addItem(SaleItemEntity item) {
    state = [...state, item];
  }

  void addProduct(dynamic product) {
    final existingIndex = state.indexWhere((item) => item.productId == product.id);
    
    if (existingIndex != -1) {
      final updatedCart = [...state];
      final item = updatedCart[existingIndex];
      updatedCart[existingIndex] = item.copyWith(
        quantity: item.quantity + 1,
        total: (item.quantity + 1) * item.price,
      );
      state = updatedCart;
    } else {
      state = [
        ...state,
        SaleItemEntity(
          id: '', // Generated on save
          saleId: '',
          productId: product.id,
          productName: product.name,
          quantity: 1,
          price: product.price,
          total: product.price,
        ),
      ];
    }
  }

  void removeItem(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i]
    ];
  }

  void updateQuantity(int index, double quantity) {
    final updatedCart = [...state];
    final item = updatedCart[index];
    updatedCart[index] = item.copyWith(
      quantity: quantity,
      total: quantity * item.price,
    );
    state = updatedCart;
  }

  void clear() {
    state = [];
  }

  double get subtotal => state.fold(0, (sum, item) => sum + item.total);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<SaleItemEntity>>((ref) {
  return CartNotifier();
});
