import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../core/constants/app_colors.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  Map<String, dynamic>? _selectedMessage;
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'title': 'Biznes Audit Hesabatı',
      'content': 'Müəllim, son analizlərimiz göstərir ki, satışlarınızda artım meyli var...',
      'type': 'audit',
      'created_at': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'unread',
    },
    {
      'id': '2',
      'title': 'Həftəlik Tövsiyə',
      'content': 'Xərclərinizi 10% azaltmaq üçün yeni logistika planı hazırladıq...',
      'type': 'recommendation',
      'created_at': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'read',
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
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: _buildMessagesList()),
                    const SizedBox(width: 24),
                    Expanded(flex: 2, child: _buildMessageViewer()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 10)],
              ),
              child: const Icon(Icons.mail_outline_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Məktublarım',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
                ),
                Text(
                  'Aİ tərəfindən hazırlanan strateji hesabatlar',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: ListView.separated(
        itemCount: _messages.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.black.withValues(alpha: 0.05)),
        itemBuilder: (context, index) {
          final msg = _messages[index];
          final isSelected = _selectedMessage?['id'] == msg['id'];
          final isUnread = msg['status'] == 'unread';

          return InkWell(
            onTap: () => setState(() => _selectedMessage = msg),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.transparent,
                border: isSelected ? const Border(left: BorderSide(color: AppColors.primary, width: 4)) : null,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: msg['type'] == 'audit' ? Colors.blue.withValues(alpha: 0.1) : Colors.amber.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      msg['type'] == 'audit' ? Icons.shield_outlined : Icons.bolt_outlined,
                      size: 18,
                      color: msg['type'] == 'audit' ? Colors.blue : Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              msg['title'] as String,
                              style: TextStyle(
                                fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                color: isUnread ? Colors.black : AppColors.textSecondary,
                              ),
                            ),
                            if (isUnread)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${msg['created_at'].day}.${msg['created_at'].month}.${msg['created_at'].year}',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageViewer() {
    if (_selectedMessage == null) {
      return GlassCard(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mark_as_unread_outlined, size: 64, color: AppColors.primary.withValues(alpha: 0.2)),
              const SizedBox(height: 16),
              const Text('Məktub seçilməyib', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Text('Oxumaq istədiyiniz hesabatın üzərinə klikləyin', style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
      );
    }

    return GlassCard(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _selectedMessage!['type'] == 'audit' ? Colors.blue.withValues(alpha: 0.1) : Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _selectedMessage!['type'] == 'audit' ? 'Audit Hesabatı' : 'Tövsiyə',
                  style: TextStyle(
                    color: _selectedMessage!['type'] == 'audit' ? Colors.blue : Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.download_rounded, color: AppColors.textSecondary)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined, color: AppColors.textSecondary)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            _selectedMessage!['title'] as String,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                '${_selectedMessage!['created_at'].day}.${_selectedMessage!['created_at'].month}.${_selectedMessage!['created_at'].year} ${_selectedMessage!['created_at'].hour}:${_selectedMessage!['created_at'].minute}',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _selectedMessage!['content'] as String,
                style: const TextStyle(fontSize: 16, height: 1.8, color: Color(0xFF334155)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          const Text(
            'Bu analiz Siam Aİ tərəfindən biznesinizin real datasına əsasən hazırlanıb.',
            style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
