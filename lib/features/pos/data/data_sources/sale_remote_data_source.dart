import 'package:supabase_flutter/supabase_flutter.dart';

class SaleRemoteDataSource {
  final SupabaseClient supabase;

  SaleRemoteDataSource(this.supabase);

  Future<List<Map<String, dynamic>>> fetchSales() async {
    final response = await supabase
        .from('sales')
        .select('*, sale_items(*)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createSale(Map<String, dynamic> saleData) async {
    // Supabase RPC or complex insert might be needed for nested items
    // For now, simpler multi-table insert if possible or separate calls
    final response = await supabase
        .from('sales')
        .insert(saleData)
        .select()
        .single();
    return response;
  }

  Future<void> createSaleItems(List<Map<String, dynamic>> items) async {
    await supabase.from('sale_items').insert(items);
  }
}
