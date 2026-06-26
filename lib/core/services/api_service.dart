// lib/core/services/api_service.dart

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _rootUrl = 'https://manbut2-production.up.railway.app';
  static const String _baseUrl = '$_rootUrl/api';
  static const String _tokenKey = 'auth_token';

  static String get rootUrl => _rootUrl;

  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (options.data is FormData) {
            options.headers.remove('Content-Type');
          }
          // ignore: avoid_print
          print('REQUEST => ${options.method} ${options.path}');
          // ignore: avoid_print
          print('REQUEST HEADERS => ${options.headers}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // ignore: avoid_print
          print('RESPONSE [${response.statusCode}] => ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // ignore: avoid_print
          print('ERROR [${e.response?.statusCode}] => ${e.requestOptions.path}');
          // ignore: avoid_print
          print('ERROR RESPONSE => ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );
  }

  // ─── Catalog ──────────────────────────────────────────────────────────────

  Future<Response> getCategories() async => _dio.get('/catalog/categories');

  Future<Response> getPlantsByCategory(String categoryId) async =>
      _dio.get('/catalog/categories/$categoryId/plants');

  Future<Response> getAllPlants({String? search, int? limit, int? page}) async =>
      _dio.get('/plants', queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (limit != null) 'limit': limit,
        if (page != null) 'page': page,
      });

  Future<Response> getPlantById(String plantId) async =>
      _dio.get('/catalog/plants/$plantId');

  // ─── Articles ─────────────────────────────────────────────────────────────

  Future<Response> getArticlesForPlant(String plantId) async =>
      _dio.get('/articles/plants/$plantId');

  Future<Response> getGeneralArticles() async => _dio.get('/articles/general');

  Future<Response> getArticleById(String articleId) async =>
      _dio.get('/articles/$articleId');

  // ─── Token ────────────────────────────────────────────────────────────────

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    // ignore: avoid_print
    print('SAVED TOKEN => $token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    // ignore: avoid_print
    print('TOKEN CLEARED');
  }

  // ─── Auth ─────────────────────────────────────────────────────────────────

  Future<Response> register({
    required String name,
    required String email,
    required String password,
  }) async =>
      _dio.post('/authentication/register',
          data: {'name': name, 'email': email, 'password': password});

  Future<Response> login({
    required String email,
    required String password,
  }) async =>
      _dio.post('/authentication/login',
          data: {'email': email, 'password': password});

  Future<Response> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async =>
      _dio.put('/authentication/change-password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      });

  Future<Response> forgotPassword({required String email}) async =>
      _dio.post('/authentication/forgot-password', data: {'email': email});

  Future<Response> resetPassword({
    required String token,
    required String newPassword,
  }) async =>
      _dio.post('/authentication/reset-password', data: {
        'token': token,
        'newPassword': newPassword,
      });

  // ─── Profile ──────────────────────────────────────────────────────────────

  Future<Response> getProfile() async => _dio.get('/user/profile');

  Future<Response> updateProfile({
    String? name,
    String? address,
    String? phone,
    String? imagePath,
    bool removeImage = false,
  }) async {
    final map = <String, dynamic>{
      if (name != null && name.isNotEmpty) 'name': name,
      if (address != null && address.isNotEmpty) 'address': address,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
    };

    if (imagePath != null && imagePath.isNotEmpty) {
      map['image'] = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      );
    } else if (removeImage) {
      map['image'] = '';
    }

    final formData = FormData.fromMap(map);
    return _dio.put('/user/profile', data: formData);
  }

  /// DELETE /user/profile — حذف الحساب نهائياً
  Future<Response> deleteAccount() async => _dio.delete('/user/profile');
}