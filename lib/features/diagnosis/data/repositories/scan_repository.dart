// lib/features/diagnosis/data/repositories/scan_repository.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:munbat_ai/core/services/api_service.dart';
import 'package:munbat_ai/features/diagnosis/data/models/scan_result_model.dart';

class ScanRepository {
  late final Dio _dio;
  final ApiService _apiService = ApiService();

  ScanRepository() {
    _dio = Dio(
      BaseOptions(
        // ✅ بقى يستخدم نفس الـ root URL الموجود في ApiService بدل رابط مختلف
        baseUrl: ApiService.rootUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
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
      ),
    );
  }

  // =========================
  // SCAN IMAGE
  // POST /api/scans
  // =========================
 Future<ScanResultModel?> scanImage(String imagePath) async {
  try {
    final file = File(imagePath);
    final fileName = imagePath.split('/').last;

    final formData = FormData.fromMap({
      'plantImage': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    final response = await _dio.post(
      '/api/scans',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return ScanResultModel.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    debugPrint('SCAN ERROR STATUS => ${e.response?.statusCode}');
    debugPrint('SCAN ERROR DATA => ${e.response?.data}');

    // ─── استخرج الـ message من الـ backend response ───
    final errorData = e.response?.data;
    if (errorData != null && errorData is Map) {
      final message = errorData['message']?.toString() ??
          errorData['error']?.toString();
      if (message != null && message.isNotEmpty) {
        // ارمي exception بالـ message الحقيقية بدل ما ترجع null
        throw ScanException(message);
      }
    }
    return null;
  } catch (e) {
    if (e is ScanException) rethrow;
    debugPrint('SCAN UNEXPECTED ERROR => $e');
    return null;
  }
}

  // =========================
  // GET ALL SCANS
  // GET /api/scans?page=&limit=
  // response: { message, data: { scans: [...], currentPage, totalPages, totalScans } }
  // =========================
  Future<List<ScanResultModel>> getAllScans() async {
    try {
      final response = await _dio.get('/api/scans');
      debugPrint('GET SCANS RESPONSE => ${response.data}');

      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      final List scansList = data['scans'] as List? ?? [];

      return scansList
          .whereType<Map>()
          .map((e) => ScanResultModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint('GET SCANS ERROR => ${e.response?.data}');
      return [];
    } catch (e) {
      debugPrint('GET SCANS UNEXPECTED ERROR => $e');
      return [];
    }
  }

  // =========================
  // GET SCAN BY ID
  // GET /api/scans/:id
  // =========================
  Future<ScanResultModel?> getScanById(String scanId) async {
    try {
      final response = await _dio.get('/api/scans/$scanId');
      return ScanResultModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('GET SCAN BY ID ERROR => ${e.response?.data}');
      return null;
    } catch (e) {
      debugPrint('GET SCAN UNEXPECTED ERROR => $e');
      return null;
    }
  }
}
class ScanException implements Exception {
  final String message;
  ScanException(this.message);
}