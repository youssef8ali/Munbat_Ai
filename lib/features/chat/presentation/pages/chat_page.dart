// lib/features/chat/presentation/pages/chat_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/chat/data/repositories/chat_repository.dart';
import 'package:munbat_ai/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:munbat_ai/features/chat/presentation/cubit/chat_state.dart';
import 'package:munbat_ai/features/chat/presentation/widgets/chat_message.dart';
import 'package:munbat_ai/features/chat/presentation/widgets/quick_action_button.dart';

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

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(BuildContext context, {String? quickMessage}) {
    final text = quickMessage ?? _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();
    context.read<ChatCubit>().sendMessage(text);
    _scrollToBottom();
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
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
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

          return Column(
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
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount:
                      state.messages.length + (state.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (state.isTyping && index == state.messages.length) {
                      return _buildTypingIndicator();
                    }
                    return ChatMessageWidget(message: state.messages[index]);
                  },
                ),
              ),

              // Quick Actions
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    // Text Field
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

                    // Send Button
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
          );
        },
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: AppColors.white, size: 20),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(200),
                const SizedBox(width: 4),
                _buildDot(400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int delayMs) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: Duration(milliseconds: 600 + delayMs),
      curve: Curves.easeInOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.textSecondary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}