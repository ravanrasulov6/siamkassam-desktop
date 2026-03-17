import 'package:supabase_flutter/supabase_flutter.dart';

class DebtRemoteDataSource {
  final SupabaseClient supabase;

  DebtRemoteDataSource(this.supabase);

  Future<List<Map<String, dynamic>>> fetchDebts() async {
    final response = await supabase
        .from('debts')
        .select()
        .order('due_date', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> upsertDebt(Map<String, dynamic> debt) async {
    final response = await supabase
        .from('debts')
        .upsert(debt)
        .select()
        .single();
    return response;
  }

  Future<void> deleteDebt(String id) async {
    await supabase.from('debts').delete().eq('id', id);
  }
}
