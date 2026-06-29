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
      'Hello! I can help you identify plant diseases and recommend treatments. Describe the issue.';

  ChatCubit(this._chatRepository) : super(ChatInitial()) {
    _init();
  }

  void _init() {
    if (isClosed) return;
    emit(ChatLoaded(
      messages: [ChatMessage(text: _welcomeMessage, isBot: true)],
    ));
  }

  // ─── Split string safely (supports emoji & UTF-16) ────────────────────────
  List<String> _splitIntoCharacters(String text) {
    return text.characters.toList();
  }

  // ─── Stream text character by character ───────────────────────────────────
  Future<void> _streamText(String fullText) async {
    final characters = _splitIntoCharacters(fullText);
    String displayed = '';

    for (final char in characters) {
      if (isClosed) return;
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

  // ─── Send message ──────────────────────────────────────────────────────────
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final current = state;
    if (current is! ChatLoaded) return;

    // 1. أضف رسالة اليوزر
    if (isClosed) return;
    emit(current.copyWith(
      messages: [...current.messages, ChatMessage(text: text, isBot: false)],
      isTyping: true,
    ));
    onScroll?.call();

    // 2. بعت للـ API
    final botReply = await _chatRepository.sendMessage(text);

    if (isClosed) return;
    final currentState = state;
    if (currentState is! ChatLoaded) return;

    final botMessage = ChatMessage(text: '', isBot: true);
    emit(currentState.copyWith(
      messages: [...currentState.messages, botMessage],
      isTyping: false,
    ));
    onScroll?.call();

    // 3. Streaming
    await _streamText(botReply);
  }

  // ─── Load existing chat from history ──────────────────────────────────────
  Future<void> loadChat(String chatId) async {
    if (isClosed) return;
    emit(ChatLoading());

    _chatRepository.setCurrentChat(chatId);
    final rawMessages = await _chatRepository.getChatMessages(chatId);

    if (isClosed) return;

    if (rawMessages.isEmpty) {
      emit(ChatLoaded(
        messages: [ChatMessage(text: _welcomeMessage, isBot: true)],
        currentChatId: chatId,
      ));
      return;
    }

    // شيل الرسائل المكررة
    final seen = <String>{};
    final deduped = rawMessages.where((m) {
      final key = '${m['sender']}_${m['content']}_${m['sent_at']}';
      return seen.add(key);
    }).toList();

    final messages = deduped.map((m) {
      return ChatMessage(
        id: m['id'],
        text: m['content'] ?? '',
        isBot: m['sender'] == 'ai',
        timestamp: DateTime.tryParse(m['sent_at'] ?? '') ?? DateTime.now(),
        status: MessageStatus.sent,
      );
    }).toList();

    if (isClosed) return;
    emit(ChatLoaded(messages: messages, currentChatId: chatId));
  }

  // ─── Get all chat IDs ─────────────────────────────────────────────────────
  Future<List<String>> getAllChatIds() async {
    return _chatRepository.getAllChatIds();
  }

  // ─── Clear / New chat ─────────────────────────────────────────────────────
  Future<void> clearChat() async {
    await _chatRepository.clearHistory();
    if (isClosed) return;
    emit(ChatLoaded(
      messages: [ChatMessage(text: _welcomeMessage, isBot: true)],
    ));
  }
}