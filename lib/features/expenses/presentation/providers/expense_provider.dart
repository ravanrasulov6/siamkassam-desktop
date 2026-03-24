import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/supabase_provider.dart';
import '../../../../core/database/isar_provider.dart';
import '../../../../core/network/connectivity_provider.dart';
import '../../data/data_sources/expense_local_data_source.dart';
import '../../data/data_sources/expense_remote_data_source.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';

final expenseLocalDataSourceProvider = Provider<ExpenseLocalDataSource>((ref) {
  return ExpenseLocalDataSource(ref.watch(isarProvider));
});

final expenseRemoteDataSourceProvider = Provider<ExpenseRemoteDataSource>((ref) {
  return ExpenseRemoteDataSource(ref.watch(supabaseClientProvider));
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return ExpenseRepositoryImpl(
    localDataSource: ref.watch(expenseLocalDataSourceProvider),
    remoteDataSource: ref.watch(expenseRemoteDataSourceProvider),
    isOnline: connectivity.value == NetworkStatus.online,
  );
});

class ExpenseListNotifier extends AsyncNotifier<List<ExpenseEntity>> {
  @override
  Future<List<ExpenseEntity>> build() async {
    return ref.watch(expenseRepositoryProvider).getExpenses();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(expenseRepositoryProvider).getExpenses());
  }
}

final expenseListProvider = AsyncNotifierProvider<ExpenseListNotifier, List<ExpenseEntity>>(() {
  return ExpenseListNotifier();
});
