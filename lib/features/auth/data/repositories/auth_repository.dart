// lib/features/auth/data/repositories/auth_repository.dart

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
      final response = await _apiService.login(email: email, password: password);
      final data = response.data;

      final token = data['token'] as String?;
      if (token != null) {
        await _apiService.saveToken(token);
        // ignore: avoid_print
        print('LOGIN SUCCESS, TOKEN SAVED => $token');
      }

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
      return AuthResult(success: false, message: _extractErrorMessage(e));
    } catch (_) {
      return AuthResult(success: false, message: 'An unexpected error occurred');
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
          name: name, email: email, password: password);
      final data = response.data;

      final token = data['token'] as String?;
      if (token != null) await _apiService.saveToken(token);

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
      return AuthResult(success: false, message: _extractErrorMessage(e));
    } catch (_) {
      return AuthResult(success: false, message: 'An unexpected error occurred');
    }
  }

  // ─── Change Password ──────────────────────────────────────────────────────

  Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return AuthResult(
        success: true,
        message: response.data['message'] ?? 'Password changed successfully',
      );
    } on DioException catch (e) {
      return AuthResult(success: false, message: _extractErrorMessage(e));
    } catch (_) {
      return AuthResult(success: false, message: 'An unexpected error occurred');
    }
  }

  // ─── Forgot Password ──────────────────────────────────────────────────────

  Future<AuthResult> forgotPassword({required String email}) async {
    try {
      final response = await _apiService.forgotPassword(email: email);
      return AuthResult(
        success: true,
        message: response.data['message'] ?? 'Reset link sent to your email',
      );
    } on DioException catch (e) {
      return AuthResult(success: false, message: _extractErrorMessage(e));
    } catch (_) {
      return AuthResult(success: false, message: 'An unexpected error occurred');
    }
  }

  // ─── Reset Password ───────────────────────────────────────────────────────

  Future<AuthResult> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      return AuthResult(
        success: true,
        message: response.data['message'] ?? 'Password reset successfully',
      );
    } on DioException catch (e) {
      return AuthResult(success: false, message: _extractErrorMessage(e));
    } catch (_) {
      return AuthResult(success: false, message: 'An unexpected error occurred');
    }
  }

  // ─── Get Profile ──────────────────────────────────────────────────────────

  Future<AuthResult> getProfile() async {
    try {
      final response = await _apiService.getProfile();
      final data = response.data;
      final userData = data['data'];
      UserModel? user;
      if (userData != null) {
        user = UserModel.fromJson(userData as Map<String, dynamic>);
      }
      return AuthResult(
        success: true,
        message: data['message'] ?? 'Profile retrieved successfully',
        user: user,
      );
    } on DioException catch (e) {
      return AuthResult(success: false, message: _extractErrorMessage(e));
    } catch (_) {
      return AuthResult(success: false, message: 'An unexpected error occurred');
    }
  }

  // ─── Update Profile ───────────────────────────────────────────────────────

  Future<AuthResult> updateProfile({
    String? name,
    String? address,
    String? phone,
  }) async {
    try {
      final response = await _apiService.updateProfile(
        name: name,
        address: address,
        phone: phone,
      );
      final data = response.data;
      final userData = data['data'];
      UserModel? user;
      if (userData != null) {
        user = UserModel.fromJson(userData as Map<String, dynamic>);
      }
      return AuthResult(
        success: true,
        message: data['message'] ?? 'Profile updated successfully',
        user: user,
      );
    } on DioException catch (e) {
      return AuthResult(success: false, message: _extractErrorMessage(e));
    } catch (_) {
      return AuthResult(success: false, message: 'An unexpected error occurred');
    }
  }

  // ─── Delete Account ───────────────────────────────────────────────────────

  /// DELETE /user/profile — حذف الحساب نهائياً ومسح الـ token
  Future<AuthResult> deleteAccount() async {
    try {
      final response = await _apiService.deleteAccount();
      await _apiService.clearToken(); // ✅ مسح الـ token بعد الحذف
      return AuthResult(
        success: true,
        message: response.data['message'] ?? 'Account deleted successfully',
      );
    } on DioException catch (e) {
      return AuthResult(success: false, message: _extractErrorMessage(e));
    } catch (_) {
      return AuthResult(success: false, message: 'An unexpected error occurred');
    }
  }

  // ─── Logout ───────────────────────────────────────────────────────────────

  Future<void> logout() async => _apiService.clearToken();

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