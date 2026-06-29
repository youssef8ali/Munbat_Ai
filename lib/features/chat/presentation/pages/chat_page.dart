// lib/features/chat/presentation/pages/chat_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/chat/data/repositories/chat_repository.dart';
import 'package:munbat_ai/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:munbat_ai/features/chat/presentation/cubit/chat_state.dart';
import 'package:munbat_ai/features/chat/presentation/pages/chat_history_page.dart';
import 'package:munbat_ai/features/chat/presentation/widgets/QuickActionButton.dart';
import 'package:munbat_ai/features/chat/presentation/widgets/chat_message.dart';
import 'package:munbat_ai/features/chat/presentation/widgets/typing_indicator.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // ✅ lazy: false عشان الـ cubit يتعمل فور ما الـ widget يتبني
      create: (_) => ChatCubit(ChatRepository()),
      lazy: false,
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _userScrolledUp = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      if (!_userScrolledUp) setState(() => _userScrolledUp = true);
    } else if (notification is ScrollEndNotification) {
      if (_scrollController.hasClients) {
        final pos = _scrollController.position;
        if (pos.pixels >= pos.maxScrollExtent - 40 && _userScrolledUp) {
          setState(() => _userScrolledUp = false);
        }
      }
    }
    return false;
  }

  void _scrollToBottom() {
    if (_userScrolledUp) return;
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _sendMessage(BuildContext context, {String? quickMessage}) {
    final text = quickMessage ?? _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();
    setState(() => _userScrolledUp = false);
    context.read<ChatCubit>().sendMessage(text);
  }

  Future<void> _openHistory(BuildContext context) async {
    // ✅ نحفظ reference للـ cubit قبل الـ navigation
    // عشان لو الـ widget اتغير مش نلاقي context قديم
    final cubit = context.read<ChatCubit>();

    final selectedChatId = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const ChatHistoryPage()),
    );

    // ✅ نتأكد إن الـ widget لسه موجود قبل نعمل أي حاجة
    if (!mounted) return;
    if (selectedChatId == null) return;

    cubit.loadChat(selectedChatId);
    setState(() => _userScrolledUp = false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            final chatId = state is ChatLoaded ? state.currentChatId : null;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Munbat Chat',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (chatId != null)
                  Text(
                    '#${chatId.length >= 6 ? chatId.substring(chatId.length - 6) : chatId}',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textSecondary),
                  ),
              ],
            );
          },
        ),
        centerTitle: true,
        // ✅ history على الشمال دايماً بغض النظر عن الـ TextDirection
        leading: IconButton(
          icon: const Icon(Icons.history, color: AppColors.textSecondary),
          tooltip: 'Chat History',
          onPressed: () => _openHistory(context),
        ),
        actions: [
          _AnimatedIconButton(
            icon: Icons.refresh,
            color: AppColors.textSecondary,
            tooltip: 'New Chat',
            onPressed: () => context.read<ChatCubit>().clearChat(),
          ),
        ],
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatLoaded) _scrollToBottom();
        },
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading chat...'),
                ],
              ),
            );
          }

          if (state is! ChatLoaded) return const SizedBox.shrink();

          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Today, ${TimeOfDay.now().format(context)}',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: _onScrollNotification,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount:
                            state.messages.length + (state.isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (state.isTyping && index == state.messages.length) {
                            return const TypingIndicator();
                          }
                          return ChatMessageWidget(
                              message: state.messages[index]);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: QuickActionButton(
                            icon: Icons.bug_report,
                            label: 'Identify this pest',
                            onTap: () => _sendMessage(context,
                                quickMessage:
                                    'Help me identify a pest on my plant'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: QuickActionButton(
                            icon: Icons.medical_services,
                            label: 'Treatment options',
                            onTap: () => _sendMessage(context,
                                quickMessage:
                                    'What are the treatment options for plant diseases?'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: TextField(
                              controller: _messageController,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _sendMessage(context),
                              decoration: InputDecoration(
                                hintText: 'Ask about a disease...',
                                hintStyle: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_upward,
                                color: AppColors.white),
                            onPressed: state.isTyping
                                ? null
                                : () => _sendMessage(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_userScrolledUp)
                Positioned(
                  bottom: 140,
                  right: 16,
                  child: FloatingActionButton.small(
                    backgroundColor: AppColors.primary,
                    onPressed: () {
                      setState(() => _userScrolledUp = false);
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    },
                    child: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.white),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Animated Icon Button ─────────────────────────────────────────────────────

class _AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onPressed;

  const _AnimatedIconButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  State<_AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<_AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_controller.isAnimating) return;
    _controller.forward(from: 0).whenComplete(() => _controller.reset());
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: IconButton(
        icon: Icon(widget.icon, color: widget.color),
        tooltip: widget.tooltip,
        onPressed: _handleTap,
      ),
    );
  }
}