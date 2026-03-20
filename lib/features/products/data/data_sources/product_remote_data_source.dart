import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRemoteDataSource {
  final SupabaseClient supabase;

  ProductRemoteDataSource(this.supabase);

  Future<List<Map<String, dynamic>>> fetchProducts(String businessId) async {
    final response = await supabase
        .from('products')
        .select()
        .eq('business_id', businessId)
        .order('name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> upsertProduct(Map<String, dynamic> product) async {
    final response = await supabase
        .from('products')
        .upsert(product)
        .select()
        .single();
    return response;
  }

  Future<void> deleteProduct(String id) async {
    await supabase.from('products').delete().eq('id', id);
  }
}
