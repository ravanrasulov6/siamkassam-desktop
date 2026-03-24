import 'package:supabase_flutter/supabase_flutter.dart';

class ExpenseRemoteDataSource {
  final SupabaseClient client;

  ExpenseRemoteDataSource(this.client);

  Future<List<Map<String, dynamic>>> fetchExpenses() async {
    final response = await client
        .from('expenses')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> upsertExpense(Map<String, dynamic> data) async {
    await client.from('expenses').upsert(data);
  }

  Future<void> deleteExpense(String id) async {
    await client.from('expenses').delete().eq('id', id);
  }
}
