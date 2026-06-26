// lib/features/chat/presentation/cubit/chat_cubit.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/features/chat/data/models/chat_message.dart';
import 'package:munbat_ai/features/chat/data/repositories/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;

  void Function()? onScroll;

  static const String _welcomeMessage =
      'Hello! I can help you identify plant diseases and recommend treatments. describe the issue.';

  static const String _offTopicReply =
      'I\'m specialized in plant care and diseases only. Please ask me about plants, diseases, or treatments! 🌱';

 



  ChatCubit(this._chatRepository) : super(ChatInitial()) {
    _init();
  }

  void _init() {
    emit(ChatLoaded(
      messages: [ChatMessage(text: _welcomeMessage, isBot: true)],
    ));
  }

  // ✅ بنقسم الـ string بـ characters صح تدعم emoji و UTF-16
  List<String> _splitIntoCharacters(String text) {
    return text.characters.toList();
  }

  Future<void> _streamText(String fullText) async {
    final characters = _splitIntoCharacters(fullText);
    String displayed = '';

    for (final char in characters) {
      displayed += char;
      final currentState = state;
      if (currentState is! ChatLoaded) break;
      final updated = List<ChatMessage>.from(currentState.messages);
      updated[updated.length - 1] =
          updated[updated.length - 1].copyWith(text: displayed);
      emit(currentState.copyWith(messages: updated));
      onScroll?.call();
      await Future.delayed(const Duration(milliseconds: 4));
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final current = state;
    if (current is! ChatLoaded) return;

    // 1. أضف رسالة اليوزر
    emit(current.copyWith(
      messages: [...current.messages, ChatMessage(text: text, isBot: false)],
      isTyping: true,
    ));
    onScroll?.call();

    // 2. لو السؤال مش عن نباتات — ارد محلياً
 

    // 3. سؤال عن نباتات — بعت للـ API
    final botReply = await _chatRepository.sendMessage(text);

    final botMessage = ChatMessage(text: '', isBot: true);
    emit((state as ChatLoaded).copyWith(
      messages: [...(state as ChatLoaded).messages, botMessage],
      isTyping: false,
    ));
    onScroll?.call();

    // 4. streaming آمن
    await _streamText(botReply);
  }

  Future<void> clearChat() async {
    await _chatRepository.clearHistory();
    emit(ChatLoaded(
      messages: [ChatMessage(text: _welcomeMessage, isBot: true)],
    ));
  }
}