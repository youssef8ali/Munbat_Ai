// lib/features/chat/presentation/cubit/chat_state.dart

import 'package:munbat_ai/features/chat/data/models/chat_message.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;

  ChatLoaded({
    required this.messages,
    this.isTyping = false,
  });

  ChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}