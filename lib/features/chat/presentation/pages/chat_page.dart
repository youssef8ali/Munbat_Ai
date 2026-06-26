// lib/features/chat/presentation/pages/chat_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/chat/data/repositories/chat_repository.dart';
import 'package:munbat_ai/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:munbat_ai/features/chat/presentation/cubit/chat_state.dart';
import 'package:munbat_ai/features/chat/presentation/widgets/QuickActionButton.dart';
import 'package:munbat_ai/features/chat/presentation/widgets/chat_message.dart';

import 'package:munbat_ai/features/chat/presentation/widgets/typing_indicator.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(ChatRepository()),
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

  // لو اليوزر سحب لفوق بنفسه، وقف الـ auto scroll
  bool _userScrolledUp = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // بنكتشف سحب اليوزر الحقيقي فورًا لحظة بدايته (مش بعد ما يتحرك)
  // عشان نلحق نوقف الـ auto-scroll قبل ما الستريمنج يعمل jumpTo تاني
  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      // لمسة سحب حقيقية من اليوزر — وقف المتابعة التلقائية فورًا
      if (!_userScrolledUp) {
        setState(() => _userScrolledUp = true);
      }
    } else if (notification is ScrollEndNotification) {
      // لما اليوزر يسيب السحب، شوف لو رجع لقرب الآخر بنفسه
      if (_scrollController.hasClients) {
        final pos = _scrollController.position;
        final isAtBottom = pos.pixels >= pos.maxScrollExtent - 40;
        if (isAtBottom && _userScrolledUp) {
          setState(() => _userScrolledUp = false);
        }
      }
    }
    return false;
  }

  void _scrollToBottom() {
    // متنزلش لو اليوزر سحب لفوق بنفسه
    if (_userScrolledUp) return;

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    }
  }

  void _sendMessage(BuildContext context, {String? quickMessage}) {
    final text = quickMessage ?? _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();
    // لما يبعت رسالة، ارجع للأسفل تلقائي
    setState(() => _userScrolledUp = false);
    context.read<ChatCubit>().sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Munbat Chat',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
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
          if (state is! ChatLoaded) return const SizedBox.shrink();

          return Stack(
            children: [
              Column(
                children: [
                  // Timestamp
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Today, ${TimeOfDay.now().format(context)}',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),

                  // Messages
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: _onScrollNotification,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount:
                            state.messages.length + (state.isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (state.isTyping &&
                              index == state.messages.length) {
                            return const TypingIndicator();
                          }
                          return ChatMessageWidget(
                              message: state.messages[index]);
                        },
                      ),
                    ),
                  ),

                  // Quick Actions
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

                  // Input Field
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

              // زر "انزل للأسفل" لما اليوزر يكون فوق
              if (_userScrolledUp)
                Positioned(
                  bottom: 140,
                  right: 16,
                  child: FloatingActionButton.small(
                    backgroundColor: AppColors.primary,
                    onPressed: () {
                      setState(() => _userScrolledUp = false);
                      _scrollController.jumpTo(
                        _scrollController.position.maxScrollExtent,
                      );
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

// ─── Reusable Animated Icon Button ─────────────────────────────────────────
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