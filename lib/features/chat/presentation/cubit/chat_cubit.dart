// lib/features/chat/presentation/cubit/chat_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/features/chat/data/models/chat_message.dart';
import 'package:munbat_ai/features/chat/data/repositories/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;

  static const String _welcomeMessage =
      'Hello! I can help you identify plant diseases and recommend treatments. Send me a photo or describe the issue.';

  ChatCubit(this._chatRepository) : super(ChatInitial()) {
    _init();
  }

  void _init() {
    emit(ChatLoaded(
      messages: [
        ChatMessage(text: _welcomeMessage, isBot: true),
      ],
    ));
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final current = state;
    if (current is! ChatLoaded) return;

    // أضف رسالة اليوزر وشغل الـ typing indicator
    final updatedMessages = [
      ...current.messages,
      ChatMessage(text: text, isBot: false),
    ];

    emit(current.copyWith(messages: updatedMessages, isTyping: true));

    // جيب الرد من الـ API
    final botReply = await _chatRepository.sendMessage(text);

    final currentState = state;
    if (currentState is! ChatLoaded) return;

    emit(currentState.copyWith(
      messages: [
        ...currentState.messages,
        ChatMessage(text: botReply, isBot: true),
      ],
      isTyping: false,
    ));
  }

  Future<void> clearChat() async {
    await _chatRepository.clearHistory();
    emit(ChatLoaded(
      messages: [
        ChatMessage(text: _welcomeMessage, isBot: true),
      ],
    ));
  }
}