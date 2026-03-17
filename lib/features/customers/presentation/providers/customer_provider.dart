import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/supabase_provider.dart';
import '../../../../core/database/isar_provider.dart';
import '../../../../core/network/connectivity_provider.dart';
import '../../data/data_sources/customer_local_data_source.dart';
import '../../data/data_sources/customer_remote_data_source.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../domain/use_cases/get_customers_use_case.dart';

final customerLocalDataSourceProvider = Provider<CustomerLocalDataSource>((ref) {
  return CustomerLocalDataSource(ref.watch(isarProvider));
});

final customerRemoteDataSourceProvider = Provider<CustomerRemoteDataSource>((ref) {
  return CustomerRemoteDataSource(ref.watch(supabaseClientProvider));
});

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return CustomerRepositoryImpl(
    localDataSource: ref.watch(customerLocalDataSourceProvider),
    remoteDataSource: ref.watch(customerRemoteDataSourceProvider),
    isOnline: connectivity.value == NetworkStatus.online,
  );
});

final getCustomersUseCaseProvider = Provider<GetCustomersUseCase>((ref) {
  return GetCustomersUseCase(ref.watch(customerRepositoryProvider));
});

class CustomerListNotifier extends AsyncNotifier<List<CustomerEntity>> {
  @override
  Future<List<CustomerEntity>> build() async {
    return ref.watch(getCustomersUseCaseProvider).call();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(getCustomersUseCaseProvider).call());
  }

  // Add more methods like addCustomer, updateCustomer
}

final customerListProvider = AsyncNotifierProvider<CustomerListNotifier, List<CustomerEntity>>(() {
  return CustomerListNotifier();
});
