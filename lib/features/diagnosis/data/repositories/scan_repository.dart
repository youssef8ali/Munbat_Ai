// lib/features/diagnosis/data/repositories/scan_repository.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:munbat_ai/core/services/api_service.dart';
import 'package:munbat_ai/features/diagnosis/data/models/scan_result_model.dart';

class ScanRepository {
  static const String _baseUrl =
      'https://manbatbackend-production.up.railway.app';

  late final Dio _dio;
  final ApiService _apiService = ApiService();

  ScanRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
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
  // بيرجع: { "data": { "PlantScan": {}, "treatments": [], "Products": [] } }
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

      debugPrint('SCANNING IMAGE: $imagePath');

      final response = await _dio.post(
        '/api/scans',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      debugPrint('SCAN RESPONSE => ${response.data}');

      return ScanResultModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('SCAN ERROR STATUS => ${e.response?.statusCode}');
      debugPrint('SCAN ERROR DATA => ${e.response?.data}');
      return null;
    } catch (e) {
      debugPrint('SCAN UNEXPECTED ERROR => $e');
      return null;
    }
  }

  // =========================
  // GET ALL SCANS
  // GET /api/scans
  // بيرجع: { "message": "...", "data": [ { "_id": "...", "treatments": [...], ... } ] }
  // =========================
  Future<List<ScanResultModel>> getAllScans() async {
    try {
      final response = await _dio.get('/api/scans');
      debugPrint('GET SCANS RESPONSE => ${response.data}');

      // الـ response دايمًا: { "message": "...", "data": [...] }
      final List data = response.data['data'] as List? ?? [];

      return data
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