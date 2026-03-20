import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerRemoteDataSource {
  final SupabaseClient supabase;

  CustomerRemoteDataSource(this.supabase);

  Future<List<Map<String, dynamic>>> fetchCustomers(String businessId) async {
    final response = await supabase
        .from('customers')
        .select()
        .eq('business_id', businessId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> upsertCustomer(Map<String, dynamic> customer) async {
    final response = await supabase
        .from('customers')
        .upsert(customer)
        .select()
        .single();
    return response;
  }
}
