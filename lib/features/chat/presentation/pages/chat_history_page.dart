// lib/features/chat/presentation/pages/chat_history_page.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/chat/data/repositories/chat_repository.dart';

class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  bool _isLoading = true;
  List<_ChatHistoryItem> _chats = [];
  String? _error;

  final _repo = ChatRepository();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final ids = await _repo.getAllChatIds();

    if (ids.isEmpty) {
      if (mounted) setState(() { _chats = []; _isLoading = false; });
      return;
    }

    final futures = ids.map((id) => _repo.getChatMessages(id)).toList();
    final results = await Future.wait(futures);

    final items = <_ChatHistoryItem>[];
    for (int i = 0; i < ids.length; i++) {
      final messages = results[i]; // List<Map<String, dynamic>>

      // ✅ FIX: orElse بترجع Map<String, dynamic> مش Map<String, String>
      Map<String, dynamic>? firstUserMsg;
      for (final m in messages) {
        if (m['sender'] == 'user') {
          firstUserMsg = m;
          break;
        }
      }

      final preview = firstUserMsg != null
          ? (firstUserMsg['content']?.toString() ?? 'No messages')
          : 'Empty chat';

      final sentAt = firstUserMsg != null
          ? (firstUserMsg['sent_at']?.toString() ?? '')
          : '';

      items.add(_ChatHistoryItem(
        chatId: ids[i],
        preview: preview,
        sentAt: sentAt,
        messageCount: messages.length,
      ));
    }

    items.sort((a, b) => b.chatId.compareTo(a.chatId));

    if (mounted) {
      setState(() {
        _chats = items;
        _isLoading = false;
      });
    }
  }

  void _openChat(String chatId) => Navigator.pop(context, chatId);

  String _formatDate(String sentAt) {
    if (sentAt.isEmpty) return '';
    try {
      final dt = DateTime.parse(sentAt).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inDays == 0) {
        return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } else if (diff.inDays == 1) {
        return 'Yesterday';
      } else if (diff.inDays < 7) {
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return days[dt.weekday - 1];
      } else {
        return '${dt.day}/${dt.month}/${dt.year}';
      }
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: بنبني الـ AppBar يدوياً من غير Scaffold appBar عشان نتحكم في الـ leading
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Custom AppBar ────────────────────────────────────
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: [
                  // الأيقونة على الشمال دايماً
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Chat History',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh,
                        color: AppColors.textSecondary),
                    tooltip: 'Refresh',
                    onPressed: _loadHistory,
                  ),
                ],
              ),
            ),

            // ─── Body ─────────────────────────────────────────────
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 56,
                color: AppColors.textSecondary.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text(_error!,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadHistory,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline,
                size: 72, color: AppColors.primary.withOpacity(0.3)),
            const SizedBox(height: 20),
            Text('No chat history yet',
                style: AppTextStyles.h3
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Text(
              'Start a conversation and it will appear here',
              style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: _chats.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return _ChatHistoryCard(
            chat: chat,
            formattedDate: _formatDate(chat.sentAt),
            onTap: () => _openChat(chat.chatId),
          );
        },
      ),
    );
  }
}

// ─── Data model ──────────────────────────────────────────────────────────────

class _ChatHistoryItem {
  final String chatId;
  final String preview;
  final String sentAt;
  final int messageCount;

  _ChatHistoryItem({
    required this.chatId,
    required this.preview,
    required this.sentAt,
    required this.messageCount,
  });
}

// ─── Card ─────────────────────────────────────────────────────────────────────

class _ChatHistoryCard extends StatelessWidget {
  final _ChatHistoryItem chat;
  final String formattedDate;
  final VoidCallback onTap;

  const _ChatHistoryCard({
    required this.chat,
    required this.formattedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final shortId = chat.chatId.length >= 6
        ? chat.chatId.substring(chat.chatId.length - 6)
        : chat.chatId;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.eco_outlined,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chat #$shortId',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (formattedDate.isNotEmpty)
                          Text(
                            formattedDate,
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.textSecondary),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chat.preview,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${chat.messageCount} messages',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary.withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right,
                  color: AppColors.textSecondary.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }
}