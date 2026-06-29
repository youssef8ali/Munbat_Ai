// lib/features/chat/data/repositories/chat_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:munbat_ai/core/services/api_service.dart';

class ChatRepository {
  static const String _baseUrl = 'https://manbut2-production.up.railway.app';

  late final Dio _dio;
  final ApiService _apiService = ApiService();

  String? _currentChatId;

  ChatRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _apiService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          debugPrint('DIO ERROR [${e.response?.statusCode}] => ${e.requestOptions.path}');
          debugPrint('DIO ERROR BODY => ${e.response?.data}');
          debugPrint('DIO ERROR TYPE => ${e.type}');
          return handler.next(e);
        },
      ),
    );
  }

  // =========================
  // CREATE CHAT
  // =========================
  Future<String?> createNewChat() async {
    try {
      final response = await _dio.get('/api/AI_chat/new_chat');
      final chatId = (response.data['chat_Id'] ?? response.data['chat_id'])?.toString();
      if (chatId == null || chatId.isEmpty) return null;
      _currentChatId = chatId;
      return _currentChatId;
    } on DioException catch (e) {
      debugPrint('CREATE CHAT ERROR => ${e.response?.data}');
      return null;
    } catch (e) {
      debugPrint('CREATE CHAT UNEXPECTED => $e');
      return null;
    }
  }

  // =========================
  // SEND MESSAGE
  // =========================
  Future<String> sendMessage(String userMessage) async {
    try {
      if (_currentChatId == null) {
        final chatId = await createNewChat();
        if (chatId == null) return 'فشل إنشاء المحادثة. تأكد من الاتصال بالإنترنت وحاول مرة أخرى.';
        _currentChatId = chatId;
      }

      final response = await _dio.post(
        '/api/AI_chat/$_currentChatId/messages',
        data: {'content': userMessage},
      );

      final botReply = response.data['aiMessage']?.toString();
      if (botReply == null || botReply.isEmpty) {
        return 'لم يتم استلام رد من الذكاء الاصطناعي. حاول مرة أخرى.';
      }
      return botReply;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) return 'انتهت جلسة تسجيل الدخول. يرجى تسجيل الدخول مرة أخرى.';
      if (e.response?.statusCode == 404) {
        _currentChatId = null;
        return 'انتهت صلاحية المحادثة. ابعت رسالتك مرة أخرى.';
      }
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        return 'انتهى وقت الانتظار. تأكد من الاتصال بالإنترنت وحاول مرة أخرى.';
      }
      return 'حدث خطأ أثناء الإرسال. حاول مرة أخرى.';
    } catch (e) {
      debugPrint('SEND UNEXPECTED => $e');
      return 'حدث خطأ غير متوقع. حاول مرة أخرى.';
    }
  }

  // =========================
  // GET MESSAGES — fixed with full error logging
  // =========================
  Future<List<Map<String, dynamic>>> getChatMessages(String chatId) async {
    try {
      final response = await _dio.get('/api/AI_chat/$chatId/messages');
      final raw = response.data;

      if (raw == null) {
        debugPrint('GET MESSAGES: null response for chatId=$chatId');
        return [];
      }

      if (raw is! List) {
        debugPrint('GET MESSAGES: unexpected type ${raw.runtimeType} for chatId=$chatId');
        return [];
      }

      return raw.map<Map<String, dynamic>>((e) {
        if (e is! Map) return {};
        return {
          'id': e['_id']?.toString() ?? '',
          'sender': e['sender']?.toString() ?? '',
          'content': e['content']?.toString() ?? '',
          'sent_at': e['sent_at']?.toString() ?? '',
        };
      }).where((m) => m.isNotEmpty).toList();

    } on DioException catch (e) {
      debugPrint('GET MESSAGES DIO ERROR [${e.response?.statusCode}] chatId=$chatId');
      debugPrint('GET MESSAGES DIO BODY => ${e.response?.data}');
      debugPrint('GET MESSAGES DIO TYPE => ${e.type}');
      debugPrint('GET MESSAGES DIO MSG => ${e.message}');
      return [];
    } catch (e, st) {
      debugPrint('GET MESSAGES UNEXPECTED ERROR => $e');
      debugPrint('STACKTRACE => $st');
      return [];
    }
  }

  // =========================
  // GET ALL CHAT IDs
  // =========================
  Future<List<String>> getAllChatIds() async {
    try {
      final response = await _dio.get('/api/AI_chat/chat_ids');
      final raw = response.data;

      if (raw == null || raw is! List) return [];

      return raw
          .map<String>((e) => e['_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    } on DioException catch (e) {
      debugPrint('GET CHAT IDs ERROR => ${e.response?.data}');
      return [];
    } catch (e) {
      debugPrint('GET CHAT IDs UNEXPECTED => $e');
      return [];
    }
  }

  // =========================
  // SET EXISTING CHAT
  // =========================
  void setCurrentChat(String chatId) {
    _currentChatId = chatId;
  }

  // =========================
  // CLEAR
  // =========================
  Future<void> clearHistory() async {
    _currentChatId = null;
  }

  String? get currentChatId => _currentChatId;
}