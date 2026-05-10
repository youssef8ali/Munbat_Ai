import 'package:dio/dio.dart';
import 'package:munbat_ai/core/services/api_service.dart';
import 'package:munbat_ai/features/auth/data/models/auth_model.dart';
 
class AuthResult {
  final bool success;
  final String? message;
  final UserModel? user;
  final String? token;
 
  AuthResult({
    required this.success,
    this.message,
    this.user,
    this.token,
  });
}
 
class AuthRepository {
  final ApiService _apiService;
 
  AuthRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();
 
  // ─── Login ────────────────────────────────────────────────────────────────
 
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.login(
        email: email,
        password: password,
      );
 
      final data = response.data;
 
      // استخرج التوكن وحفظه
      final token = data['token'] as String?;
      if (token != null) {
        await _apiService.saveToken(token);
      }
 
      // استخرج بيانات اليوزر
      final userData = data['data'] ?? data['user'];
      UserModel? user;
      if (userData != null) {
        user = UserModel.fromJson(userData as Map<String, dynamic>);
      }
 
      return AuthResult(
        success: true,
        message: data['message'] ?? 'Login successful',
        user: user,
        token: token,
      );
    } on DioException catch (e) {
      return AuthResult(
        success: false,
        message: _extractErrorMessage(e),
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'An unexpected error occurred, please try again',
      );
    }
  }
 
  // ─── Register ─────────────────────────────────────────────────────────────
 
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.register(
        name: name,
        email: email,
        password: password,
      );
 
      final data = response.data;
 
      // بعض الـ APIs بترجع التوكن مع الـ register
      final token = data['token'] as String?;
      if (token != null) {
        await _apiService.saveToken(token);
      }
 
      final userData = data['data'] ?? data['user'];
      UserModel? user;
      if (userData != null) {
        user = UserModel.fromJson(userData as Map<String, dynamic>);
      }
 
      return AuthResult(
        success: true,
        message: data['message'] ?? 'Account created successfully',
        user: user,
        token: token,
      );
    } on DioException catch (e) {
      return AuthResult(
        success: false,
        message: _extractErrorMessage(e),
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'An unexpected error occurred, please try again',
      );
    }
  }
 
  // ─── Logout ───────────────────────────────────────────────────────────────
 
  Future<void> logout() async {
    await _apiService.clearToken();
  }
 
  // ─── Check Auth ───────────────────────────────────────────────────────────
 
  Future<bool> isLoggedIn() async {
    final token = await _apiService.getToken();
    return token != null;
  }
 
  // ─── Helper ───────────────────────────────────────────────────────────────
 
  String _extractErrorMessage(DioException e) {
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            'Something went wrong, please try again';
      }
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Network timeout, check your internet and try again';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return 'Something went wrong, please try again';
    }
  }
}