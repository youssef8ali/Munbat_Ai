// lib/features/store/data/repositories/store_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:munbat_ai/core/services/api_service.dart';
import 'package:munbat_ai/features/store/data/models/store_models.dart';

class StoreRepository {
  static const String _baseUrl =
      'https://manbut2-production.up.railway.app/api';

  late final Dio _dio;
  final ApiService _apiService = ApiService();

  StoreRepository() {
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
          debugPrint('TOKEN => $token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  // ───────────────── GET PRODUCTS ─────────────────

  Future<ProductsResponse?> getProducts({
    int page = 1,
    int limit = 10,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? categoryId,
  }) async {
    try {
      final response = await _dio.get(
        '/product',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (search != null && search.isNotEmpty) 'search': search,
          if (minPrice != null) 'minPrice': minPrice,
          if (maxPrice != null) 'maxPrice': maxPrice,
          if (categoryId != null && categoryId.isNotEmpty)
            'category': categoryId,
        },
      );

      final rawData = response.data as Map<String, dynamic>;
      final products = rawData['data']?['products'] as List? ?? [];
      if (products.isNotEmpty) {
        debugPrint('FIRST PRODUCT: ${products.first}');
      }

      return ProductsResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('GET PRODUCTS ERROR => ${e.response?.data}');
      return null;
    }
  }

  // ───────────────── GET CART ─────────────────

  Future<CartModel?> getCart() async {
    try {
      final response = await _dio.get('/cart');
      debugPrint('GET CART => ${response.data}');
      return CartModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('GET CART ERROR => ${e.response?.data}');
      return null;
    }
  }

  // ───────────────── GET CATEGORIES ─────────────────

  Future<List<CategoryModel>?> getCategories() async {
    try {
      final response = await _dio.get('/product/categories');
      debugPrint('GET CATEGORIES => ${response.data}');
      return CategoriesResponse.fromJson(
        response.data as Map<String, dynamic>,
      ).categories;
    } on DioException catch (e) {
      debugPrint('GET CATEGORIES ERROR => ${e.response?.data}');
      return null;
    }
  }

  // ───────────────── ADD TO CART ─────────────────

  Future<CartModel?> addToCart({
    required String productId,
    required int quantity,
    required double price,
  }) async {
    try {
      final body = {
        "product_id": productId,
        "quantity": quantity,
        "price": price,
      };
      debugPrint('ADD TO CART BODY => $body');
      final response = await _dio.post('/cart/add', data: body);
      debugPrint('ADD TO CART SUCCESS => ${response.data}');
      return CartModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('ADD TO CART ERROR => ${e.response?.data}');
      return null;
    }
  }

  // ───────────────── REMOVE FROM CART ─────────────────

  Future<bool> removeFromCart(String productId) async {
    try {
      final response = await _dio.post(
        '/cart/remove',
        data: {"product_id": productId},
      );
      debugPrint('REMOVE FROM CART => ${response.data}');
      return true;
    } on DioException catch (e) {
      debugPrint('REMOVE FROM CART ERROR => ${e.response?.data}');
      return false;
    }
  }

  // ───────────────── PLACE ORDER ─────────────────

  // ✅ أضفنا phone parameter
  Future<bool> placeOrder(String shippingAddress, String phone) async {
    try {
      final body = {
        "shipping_address": shippingAddress,
        "phone": phone, // ✅ جديد
      };
      debugPrint('PLACE ORDER BODY => $body');
      final response = await _dio.post('/orders', data: body);
      debugPrint('PLACE ORDER => ${response.data}');
      return true;
    } on DioException catch (e) {
      debugPrint('PLACE ORDER ERROR => ${e.response?.data}');
      return false;
    }
  }

  // ───────────────── GET ORDERS ─────────────────

  Future<List<OrderModel>?> getMyOrders() async {
    try {
      final response = await _dio.get('/orders');
      debugPrint('GET ORDERS => ${response.data}');
      final data = response.data['data'];
      if (data is List) {
        return data.map((e) => OrderModel.fromJson(e)).toList();
      }
      if (data is Map && data['orders'] is List) {
        return (data['orders'] as List)
            .map((e) => OrderModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('GET ORDERS ERROR => ${e.response?.data}');
      return null;
    }
  }
}