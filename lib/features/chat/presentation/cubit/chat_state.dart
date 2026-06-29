// lib/features/chat/presentation/cubit/chat_state.dart

import 'package:munbat_ai/features/chat/data/models/chat_message.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String? currentChatId;

  ChatLoaded({
    required this.messages,
    this.isTyping = false,
    this.currentChatId,
  });

  ChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    String? currentChatId,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      currentChatId: currentChatId ?? this.currentChatId,
    );
  }
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}