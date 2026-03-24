import '../providers/sale_provider.dart';
import '../../domain/entities/sale_entity.dart';
import 'package:intl/intl.dart';

class SalesListScreen extends ConsumerStatefulWidget {
  const SalesListScreen({super.key});

  @override
  ConsumerState<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends ConsumerState<SalesListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final salesAsync = ref.watch(saleListProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9), Color(0xFFF8FAFC)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: salesAsync.when(
            data: (sales) {
              final filteredSales = sales.where((sale) {
                final query = _searchController.text.toLowerCase();
                return sale.id.toLowerCase().contains(query) ||
                    (sale.customerName?.toLowerCase().contains(query) ?? false);
              }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildKPIs(sales),
                  const SizedBox(height: 32),
                  _buildFilters(),
                  const SizedBox(height: 24),
                  Expanded(child: _buildSalesTable(filteredSales)),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Xəta: $err')),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Satışlar',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
            ),
            Text('Bütün satış əməliyyatlarına buradan nəzarət edin', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.file_download_outlined),
          label: const Text('Export Excel'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textSecondary,
            elevation: 0,
            side: const BorderSide(color: Color(0xFFE2E8F0)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildKPIs(List<SaleEntity> sales) {
    final now = DateTime.now();
    final todaySales = sales.where((s) => s.createdAt.day == now.day && s.createdAt.month == now.month && s.createdAt.year == now.year);
    final todayTotal = todaySales.fold(0.0, (sum, s) => sum + s.total);
    
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final weeklySales = sales.where((s) => s.createdAt.isAfter(sevenDaysAgo));
    final weeklyTotal = weeklySales.fold(0.0, (sum, s) => sum + s.total);
    
    final avgCheck = sales.isEmpty ? 0.0 : sales.fold(0.0, (sum, s) => sum + s.total) / sales.length;
    final grandTotal = sales.fold(0.0, (sum, s) => sum + s.total);

    return Row(
      children: [
        Expanded(
          child: KPICard(
            title: 'Bugünkü Satış',
            value: '₼ ${todayTotal.toStringAsFixed(2)}',
            subtitle: 'Bugün cəmi ${todaySales.length} satış',
            icon: Icons.calendar_today_rounded,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: KPICard(
            title: 'Həftəlik Satış',
            value: '₼ ${weeklyTotal.toStringAsFixed(2)}',
            subtitle: 'Son 7 gündə',
            icon: Icons.show_chart_rounded,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: KPICard(
            title: 'Orta Çek',
            value: '₼ ${avgCheck.toStringAsFixed(2)}',
            subtitle: 'Hər satış üzrə orta',
            icon: Icons.receipt_long_rounded,
            color: Colors.teal,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: KPICard(
            title: 'Cəmi Satış',
            value: '₼ ${NumberFormat('#,###').format(grandTotal)}',
            subtitle: 'Bütün dövrlər üçün',
            icon: Icons.account_balance_wallet_rounded,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() {}),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                hintText: 'Satış ID və ya müştəri axtar...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildFilterButton('Status', Icons.filter_list_rounded),
        const SizedBox(width: 12),
        _buildFilterButton('Tarix', Icons.event_note_rounded),
      ],
    );
  }

  Widget _buildFilterButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSalesTable(List<SaleEntity> sales) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          child: sales.isEmpty 
          ? const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: Text('Hələ ki satış yoxdur')),
            )
          : DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
            horizontalMargin: 24,
            columnSpacing: 40,
            columns: const [
              DataColumn(label: Text('SATiş ID', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('MÜŞTƏRi', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('MƏBLƏĞ', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ÖDƏNiŞ', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('TARiX', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ƏMƏLLƏR', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: sales.map((sale) {
              return DataRow(cells: [
                DataCell(Text(sale.id.substring(0, 8).toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary))),
                DataCell(Text(sale.customerName ?? 'Anonim')),
                DataCell(Text('₼${sale.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(_buildStatusBadge(sale.paymentMethod == 'cash' ? 'Nəğd' : (sale.paymentMethod == 'card' ? 'Kart' : 'Nisyə'))),
                DataCell(Text(DateFormat('dd.MM.yyyy HH:mm').format(sale.createdAt))),
                DataCell(Row(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.print_outlined, size: 20, color: AppColors.textSecondary)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.remove_red_eye_outlined, size: 20, color: AppColors.textSecondary)),
                  ],
                )),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String method) {
    Color color;
    switch (method) {
      case 'Nəğd': color = Colors.green; break;
      case 'Kart': color = Colors.blue; break;
      case 'Nisyə': color = Colors.orange; break;
      default: color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(
        method,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }
}
