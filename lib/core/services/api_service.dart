import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
class ApiService {
  static const String _baseUrl = 'https://manbatbackend-production.up.railway.app/api';
  static const String _tokenKey = 'auth_token';
 
  late final Dio _dio;
 
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );
 
    // Interceptor: يضيف التوكن تلقائياً في كل request
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }
 
  // ─── Token Storage ────────────────────────────────────────────────────────
 
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
 
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
 
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
 
  // ─── Auth Endpoints ───────────────────────────────────────────────────────
 
  /// POST /authentication/register
  Future<Response> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _dio.post(
      '/authentication/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }
 
  /// POST /authentication/login
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await _dio.post(
      '/authentication/login',
      data: {
        'email': email,
        'password': password,
      },
    );
  }
 
  // ─── User Profile ─────────────────────────────────────────────────────────
 
  /// GET /user/profile
  Future<Response> getProfile() async {
    return await _dio.get('/user/profile');
  }
 
  /// PUT /user/profile
  Future<Response> updateProfile({
    String? name,
    String? address,
    String? phone,
  }) async {
    return await _dio.put(
      '/user/profile',
      data: {
        if (name != null) 'name': name,
        if (address != null) 'address': address,
        if (phone != null) 'phone': phone,
      },
    );
  }
}