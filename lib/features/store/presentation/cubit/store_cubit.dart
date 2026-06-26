// lib/features/store/presentation/cubit/store_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/features/store/data/models/store_models.dart';
import 'package:munbat_ai/features/store/data/repositories/store_repository.dart';
import 'store_state.dart';

// ─── Store Cubit ──────────────────────────────────────────────────────────────
class StoreCubit extends Cubit<StoreState> {
  final StoreRepository _repo;
  String _searchQuery = '';
  String? _selectedCategoryId;
  List<CategoryModel> _categories = [];

  StoreCubit(this._repo) : super(StoreInitial());

  Future<void> loadStore() async {
    emit(StoreLoading());
    await _loadCategories();
    await _fetchProducts(page: 1);
  }

  Future<void> _loadCategories() async {
    final categories = await _repo.getCategories();
    if (categories != null) _categories = categories;
  }

  Future<void> goToPage(int page) async {
    final current = state;
    if (current is! StoreSuccess) return;
    if (page < 1 || page > current.totalPages) return;
    emit(current.copyWith(isLoadingProducts: true));
    await _fetchProducts(page: page);
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    final current = state;
    if (current is StoreSuccess) {
      emit(current.copyWith(isLoadingProducts: true));
    } else {
      emit(StoreLoading());
    }
    await _fetchProducts(page: 1, search: query);
  }

  Future<void> selectCategory(String? categoryId) async {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    final current = state;
    if (current is StoreSuccess) {
      emit(current.copyWith(
        isLoadingProducts: true,
        selectedCategoryId: categoryId,
        clearSelectedCategory: categoryId == null,
      ));
    } else {
      emit(StoreLoading());
    }
    await _fetchProducts(page: 1);
  }

  Future<void> _fetchProducts({int page = 1, String? search}) async {
    final result = await _repo.getProducts(
      page: page,
      search: search ?? _searchQuery,
      categoryId: _selectedCategoryId,
    );
    final cart = await _repo.getCart();
    if (result != null) {
      emit(StoreSuccess(
        products: result.products,
        cart: cart,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
        totalProducts: result.totalProducts,
        categories: _categories,
        selectedCategoryId: _selectedCategoryId,
        isLoadingProducts: false,
      ));
    } else {
      emit(StoreError('Failed to load products'));
    }
  }

  Future<void> addToCart({
    required String productId,
    required double price,
  }) async {
    final current = state;
    if (current is! StoreSuccess) return;
    final cart = await _repo.addToCart(
      productId: productId,
      quantity: 1,
      price: price,
    );
    if (cart != null) emit(current.copyWith(cart: cart));
  }

  Future<void> refreshCart() async {
    final current = state;
    if (current is! StoreSuccess) return;
    final cart = await _repo.getCart();
    if (cart != null) emit(current.copyWith(cart: cart));
  }
}

// ─── Cart Cubit ───────────────────────────────────────────────────────────────
class CartCubitStore extends Cubit<CartState> {
  final StoreRepository _repo;

  CartCubitStore(this._repo) : super(CartInitial());

  Future<void> loadCart() async {
    emit(CartLoading());
    final cart = await _repo.getCart();
    if (isClosed) return;
    if (cart != null) {
      emit(CartSuccess(cart));
    } else {
      emit(CartError('Failed to load cart'));
    }
  }

  Future<void> removeItem(String productId) async {
    final current = state;
    if (current is! CartSuccess) return;
    final success = await _repo.removeFromCart(productId);
    if (success) await loadCart();
  }

  // ✅ جديد: تضيف كل المنتجات للكارت وترجع true لو نجحت
  Future<bool> addAllProductsToCart(List<ProductModel> products) async {
    for (final product in products) {
      final result = await _repo.addToCart(
        productId: product.id,
        quantity: 1,
        price: product.discountedPrice,
      );
      if (result == null) return false;
    }
    return true;
  }
}

// ─── Order Cubit ──────────────────────────────────────────────────────────────
class OrderCubit extends Cubit<OrderState> {
  final StoreRepository _repo;

  OrderCubit(this._repo) : super(OrderInitial());

  Future<void> loadOrders() async {
    emit(OrderLoading());
    final orders = await _repo.getMyOrders();
    if (orders == null) {
      emit(OrderError('Failed to load orders. Please check your connection.'));
    } else {
      emit(OrderSuccess(orders));
    }
  }

  // ✅ أضفنا phone parameter
  Future<void> placeOrder(String shippingAddress, String phone) async {
    emit(OrderLoading());
    final success = await _repo.placeOrder(shippingAddress, phone);
    if (success) {
      emit(OrderPlaced());
    } else {
      emit(OrderError('Failed to place order'));
    }
  }
}