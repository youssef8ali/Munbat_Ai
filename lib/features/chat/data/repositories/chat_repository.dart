// lib/features/chat/data/repositories/chat_repository.dart
 
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:munbat_ai/core/services/api_service.dart';
 
class ChatRepository {
  static const String _baseUrl =
      'https://manbut2-production.up.railway.app';
 
  late final Dio _dio;
  final ApiService _apiService = ApiService();
 
  String? _currentChatId;
 
  ChatRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
 
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _apiService.getToken();
 
          debugPrint('TOKEN => $token');
 
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
 
          return handler.next(options);
        },
      ),
    );
  }
 
  // =========================
  // CREATE CHAT
  // =========================
  Future<String?> createNewChat() async {
    try {
      // ✅ FIX: الـ endpoint الصح هو /api/AI_chat/new_chat
      final response = await _dio.get('/api/AI_chat/new_chat');
 
      debugPrint('CREATE CHAT RESPONSE => ${response.data}');
 
      final data = response.data;
 
      // ✅ بيتعامل مع chat_Id و chat_id الاتنين
      final chatId = (data['chat_Id'] ?? data['chat_id'])?.toString();
 
      if (chatId == null || chatId.isEmpty) {
        debugPrint('CHAT ID NOT FOUND IN RESPONSE: $data');
        return null;
      }
 
      _currentChatId = chatId;
 
      debugPrint('CURRENT CHAT ID => $_currentChatId');
 
      return _currentChatId;
    } on DioException catch (e) {
      debugPrint('CREATE CHAT ERROR => ${e.response?.data}');
      debugPrint('STATUS => ${e.response?.statusCode}');
      return null;
    } catch (e) {
      debugPrint('CREATE CHAT UNEXPECTED ERROR => $e');
      return null;
    }
  }
 
  // =========================
  // SEND MESSAGE
  // =========================
  Future<String> sendMessage(String userMessage) async {
    try {
      // ✅ لو مفيش chat، اعمل واحد جديد
      if (_currentChatId == null) {
        final chatId = await createNewChat();
 
        if (chatId == null) {
          return 'فشل إنشاء المحادثة. تأكد من الاتصال بالإنترنت وحاول مرة أخرى.';
        }
 
        _currentChatId = chatId;
      }
 
      debugPrint('SENDING MESSAGE TO CHAT: $_currentChatId');
      debugPrint('MESSAGE: $userMessage');
 
      // ✅ FIX: الـ endpoint الصح هو /api/AI_chat/{chatId}/messages
      final response = await _dio.post(
        '/api/AI_chat/$_currentChatId/messages',
        data: {
          'content': userMessage,
        },
      );
 
      debugPrint('SEND RESPONSE => ${response.data}');
 
      final data = response.data;
 
      final botReply = data['aiMessage']?.toString();
 
      if (botReply == null || botReply.isEmpty) {
        debugPrint('NO AI REPLY IN RESPONSE: $data');
        return 'لم يتم استلام رد من الذكاء الاصطناعي. حاول مرة أخرى.';
      }
 
      return botReply;
    } on DioException catch (e) {
      debugPrint('SEND ERROR STATUS => ${e.response?.statusCode}');
      debugPrint('SEND ERROR DATA => ${e.response?.data}');
 
      if (e.response?.statusCode == 401) {
        return 'انتهت جلسة تسجيل الدخول. يرجى تسجيل الدخول مرة أخرى.';
      } else if (e.response?.statusCode == 404) {
        debugPrint('CHAT NOT FOUND — resetting chatId');
        _currentChatId = null;
        return 'انتهت صلاحية المحادثة. ابعت رسالتك مرة أخرى.';
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return 'انتهى وقت الانتظار. تأكد من الاتصال بالإنترنت وحاول مرة أخرى.';
      }
 
      return 'حدث خطأ أثناء الإرسال. حاول مرة أخرى.';
    } catch (e) {
      debugPrint('SEND UNEXPECTED ERROR => $e');
      return 'حدث خطأ غير متوقع. حاول مرة أخرى.';
    }
  }
 
  // =========================
  // GET MESSAGES
  // =========================
  Future<List<Map<String, dynamic>>> getChatMessages(String chatId) async {
    try {
      // ✅ FIX: /api/AI_chat/{chatId}/messages
      final response = await _dio.get('/api/AI_chat/$chatId/messages');
 
      debugPrint('GET MESSAGES RESPONSE => ${response.data}');
 
      final List data = response.data;
 
      return data
          .map((e) => {
                'id': e['_id']?.toString() ?? '',
                'sender': e['sender']?.toString() ?? '',
                'content': e['content']?.toString() ?? '',
                'sent_at': e['sent_at']?.toString() ?? '',
              })
          .toList();
    } on DioException catch (e) {
      debugPrint('GET MESSAGES ERROR => ${e.response?.data}');
      return [];
    } catch (e) {
      debugPrint('GET MESSAGES UNEXPECTED ERROR => $e');
      return [];
    }
  }
 
  // =========================
  // GET ALL CHAT IDs
  // =========================
  Future<List<String>> getAllChatIds() async {
    try {
      // ✅ FIX: /api/AI_chat/chat_ids
      final response = await _dio.get('/api/AI_chat/chat_ids');
 
      debugPrint('GET CHAT IDs RESPONSE => ${response.data}');
 
      final List data = response.data;
 
      return data
          .map((e) => e['_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    } on DioException catch (e) {
      debugPrint('GET CHAT IDs ERROR => ${e.response?.data}');
      return [];
    } catch (e) {
      debugPrint('GET CHAT IDs UNEXPECTED ERROR => $e');
      return [];
    }
  }
 
  // =========================
  // CLEAR / RESET
  // =========================
  Future<void> clearHistory() async {
    _currentChatId = null;
    debugPrint('CHAT HISTORY CLEARED — next message will create a new chat');
  }
 
  String? get currentChatId => _currentChatId;
}