// lib/features/chat/data/models/chat_message.dart
 
enum MessageStatus { sending, sent, error }
 
class ChatMessage {
  final String id;
  final String text;
  final bool isBot;
  final DateTime timestamp;
  final MessageStatus status;
 
  ChatMessage({
    String? id,
    required this.text,
    required this.isBot,
    DateTime? timestamp,
    this.status = MessageStatus.sent,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp = timestamp ?? DateTime.now();
 
  ChatMessage copyWith({
    String? text,
    MessageStatus? status,
  }) {
    return ChatMessage(
      id: id,
      text: text ?? this.text,
      isBot: isBot,
      timestamp: timestamp,
      status: status ?? this.status,
    );
  }
}