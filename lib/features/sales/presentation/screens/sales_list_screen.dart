import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/kpi_card.dart';
import '../../../../core/constants/app_colors.dart';

class SalesListScreen extends ConsumerStatefulWidget {
  const SalesListScreen({super.key});

  @override
  ConsumerState<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends ConsumerState<SalesListScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _sales = [
    {
      'id': 'S-1001',
      'customer': 'Rəvan Rəsulov',
      'amount': 1250.50,
      'method': 'Nəğd',
      'status': 'Completed',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': 'S-1002',
      'customer': 'Anonim',
      'amount': 45.00,
      'method': 'Kart',
      'status': 'Completed',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
    },
    {
      'id': 'S-1003',
      'customer': 'Siam Kassam',
      'amount': 320.00,
      'method': 'Nisyə',
      'status': 'Completed',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildKPIs(),
              const SizedBox(height: 32),
              _buildFilters(),
              const SizedBox(height: 24),
              Expanded(child: _buildSalesTable()),
            ],
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

  Widget _buildKPIs() {
    return const Row(
      children: [
        Expanded(
          child: KPICard(
            title: 'Bugünkü Satış',
            value: '₼ 1,295.50',
            subtitle: 'Bugün cəmi 12 satış',
            icon: Icons.calendar_today_rounded,
            color: Colors.blue,
            trend: 12.5,
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          child: KPICard(
            title: 'Həftəlik Satış',
            value: '₼ 8,450.00',
            subtitle: 'Son 7 gündə',
            icon: Icons.show_chart_rounded,
            color: Colors.indigo,
            trend: 8.2,
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          child: KPICard(
            title: 'Orta Çek',
            value: '₼ 48.20',
            subtitle: 'Hər satış üzrə orta',
            icon: Icons.receipt_long_rounded,
            color: Colors.teal,
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          child: KPICard(
            title: 'Cəmi Satış',
            value: '₼ 42,120',
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

  Widget _buildSalesTable() {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          child: DataTable(
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
            rows: _sales.map((sale) {
              return DataRow(cells: [
                DataCell(Text(sale['id'] as String, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary))),
                DataCell(Text(sale['customer'] as String)),
                DataCell(Text('₼${(sale['amount'] as double).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(_buildStatusBadge(sale['method'] as String)),
                DataCell(Text('${(sale['date'] as DateTime).day}.${(sale['date'] as DateTime).month}.${(sale['date'] as DateTime).year}')),
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
