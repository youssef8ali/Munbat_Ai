// lib/features/store/presentation/cubit/store_state.dart

import 'package:munbat_ai/features/store/data/models/store_models.dart';

abstract class StoreState {}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreSuccess extends StoreState {
  final List<ProductModel> products;
  final CartModel? cart;
  final int currentPage;
  final int totalPages;
  final int totalProducts;
  final bool isLoadingMore;
  final bool isLoadingProducts;
  final List<CategoryModel> categories;
  final String? selectedCategoryId;

  StoreSuccess({
    required this.products,
    this.cart,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalProducts = 0,
    this.isLoadingMore = false,
    this.isLoadingProducts = false,
    this.categories = const [],
    this.selectedCategoryId,
  });

  StoreSuccess copyWith({
    List<ProductModel>? products,
    CartModel? cart,
    int? currentPage,
    int? totalPages,
    int? totalProducts,
    bool? isLoadingMore,
    bool? isLoadingProducts,
    List<CategoryModel>? categories,
    String? selectedCategoryId,
    bool clearSelectedCategory = false, // ← جديد: عشان نقدر نمسحها لـ null
  }) {
    return StoreSuccess(
      products: products ?? this.products,
      cart: cart ?? this.cart,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalProducts: totalProducts ?? this.totalProducts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      categories: categories ?? this.categories,
      selectedCategoryId: clearSelectedCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
    );
  }

  int get cartItemCount => cart?.itemCount ?? 0;
}

class StoreError extends StoreState {
  final String message;
  StoreError(this.message);
}

// ─── Cart States ──────────────────────────────────────────────────────────────
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final CartModel cart;
  CartSuccess(this.cart);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}

// ─── Order States ─────────────────────────────────────────────────────────────
abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final List<OrderModel> orders;
  OrderSuccess(this.orders);
}

class OrderPlaced extends OrderState {}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}