// lib/features/store/data/models/store_models.dart

// ─── Product Model ────────────────────────────────────────────────────────────
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double discountedPrice;
  final int discount;
  final String status;
  final int quantity;
  final String imageUrl;
  final String treatmentId;
  final String treatmentName;
  final String categoryId;
  final String categoryName;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discountedPrice,
    required this.discount,
    required this.status,
    required this.quantity,
    required this.imageUrl,
    required this.treatmentId,
    required this.treatmentName,
    this.categoryId = '',
    this.categoryName = '',
  });
static String _deriveStatus(Map<String, dynamic> json) {
  // لو الـ API بعت status صريح نستخدمه
  final raw = json['status']?.toString();
  if (raw != null && raw.isNotEmpty) return raw.toLowerCase();

  // لو مفيش status نحسبها من quantity
  final qty = (json['quantity'] ?? 0).toInt();
  if (qty == 0) return 'out_of_stock';
  if (qty <= 10) return 'low_stock';
  return 'in_stock';
}

  factory ProductModel.fromJson(Map<String, dynamic> json) {
      print('STATUS RAW: ${json['status']}');  // ← هنا
  print('PRODUCT KEYS: ${json.keys.toList()}'); 
    final treatment = json['treatment_id'];
    final category = json['product_category_id'] ?? json['category_id'] ?? json['category'];

    return ProductModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] ?? 0).toDouble(),
      // بعد ✅
discountedPrice: () {
  final price = (json['price'] ?? 0).toDouble();
  final discount = (json['discount'] ?? 0).toInt();
  final apiDiscountedPrice = (json['discountedPrice'] ?? 0).toDouble();
  
  // لو الـ API بعت discountedPrice صح (أقل من price) نستخدمه
  // لو لأ نحسبها احنا
  if (apiDiscountedPrice > 0 && apiDiscountedPrice < price) {
    return apiDiscountedPrice;
  }
  if (discount > 0) {
    return price * (1 - discount / 100);
  }
  return price;
}(),
      discount: (json['discount'] ?? 0).toInt(),
      quantity: (json['quantity'] ?? 0).toInt(),
      imageUrl: json['image_url']?.toString() ?? '',
      treatmentId: treatment is Map ? treatment['_id']?.toString() ?? '' : '',
      treatmentName: treatment is Map ? treatment['name']?.toString() ?? '' : '',
      status: _deriveStatus(json),
      categoryId: category is Map
          ? (category['_id']?.toString() ?? '')
          : (category?.toString() ?? ''),
      categoryName: category is Map ? (category['name']?.toString() ?? '') : '',
    );
  }
}

// ─── Products Response ────────────────────────────────────────────────────────
class ProductsResponse {
  final List<ProductModel> products;
  final int currentPage;
  final int totalPages;
  final int totalProducts;

  ProductsResponse({
    required this.products,
    required this.currentPage,
    required this.totalPages,
    required this.totalProducts,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final list = data['products'] as List? ?? [];
    return ProductsResponse(
      products: list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: (data['currentPage'] ?? 1).toInt(),
      totalPages: (data['totalPages'] ?? 1).toInt(),
      totalProducts: (data['totalProducts'] ?? 0).toInt(),
    );
  }
}

// ─── Category Model ───────────────────────────────────────────────────────────
class CategoryModel {
  final String id;
  final String name;
  final String? imageUrl;

  CategoryModel({required this.id, required this.name, this.imageUrl});

  factory CategoryModel.fromJson(dynamic json) {
    if (json is String) return CategoryModel(id: json, name: json);
    if (json is Map) {
      final map = json as Map<String, dynamic>;
      return CategoryModel(
        id: (map['_id'] ?? map['id'] ?? map['slug'] ?? map['name'] ?? '').toString(),
        name: (map['name'] ?? map['title'] ?? map['_id'] ?? '').toString(),
        imageUrl: map['image_url']?.toString() ?? map['image']?.toString(),
      );
    }
    return CategoryModel(id: '', name: '');
  }
}

// ─── Categories Response ──────────────────────────────────────────────────────
class CategoriesResponse {
  final List<CategoryModel> categories;

  CategoriesResponse({required this.categories});

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final list = data is List ? data : <dynamic>[];
    return CategoriesResponse(
      categories: list.map((e) => CategoryModel.fromJson(e)).toList(),
    );
  }
}

// ─── Cart Item Model ──────────────────────────────────────────────────────────
class CartItemModel {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;        // السعر بعد الخصم (اللي اتبعت للكارت)
  final double originalPrice; // ← جديد: السعر الأصلي قبل الخصم
  final int quantity;
  final String? status;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.originalPrice, // ← جديد
    required this.quantity,
    this.status,
  });
static String _deriveStatus(Map<String, dynamic> json) {
  final qty = (json['quantity'] ?? 0).toInt();
  if (qty == 0) return 'out_of_stock';
  if (qty <= 10) return 'low_stock';
  return 'in_stock';
}
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product_id'];

    final double savedPrice = (json['price'] ?? 0).toDouble();
    final double productPrice =
        product is Map ? (product['price'] ?? 0).toDouble() : 0.0;
    final double price = savedPrice > 0 ? savedPrice : productPrice;

    return CartItemModel(
      productId: product is Map
          ? (product['_id']?.toString() ?? '')
          : (json['product_id']?.toString() ?? ''),
      name: product is Map ? (product['name']?.toString() ?? '') : '',
      imageUrl: product is Map ? (product['image_url']?.toString() ?? '') : '',
      price: price,
      // السعر الأصلي دايمًا من المنتج نفسه مش من الكارت
      originalPrice: productPrice > 0 ? productPrice : price, // ← جديد
      quantity: (json['quantity'] ?? 1).toInt(),
    status: product is Map
    ? _deriveStatus(product as Map<String, dynamic>)
    : null,
    );
  }

  double get totalPrice => price * quantity;
}

// ─── Cart Model ───────────────────────────────────────────────────────────────
class CartModel {
  final String id;
  final List<CartItemModel> items;
  final double totalPrice;

  CartModel({required this.id, required this.items, required this.totalPrice});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = {};

    if (json['data'] != null) {
      final d = json['data'];
      if (d is Map<String, dynamic>) {
        // بعض الـ endpoints بترجع cart جوا data
        data = (d['cart'] is Map<String, dynamic>)
            ? d['cart'] as Map<String, dynamic>
            : d;
      }
    } else {
      data = json;
    }

    final itemsRaw = data['items'] as List? ?? [];
    final items = itemsRaw
        .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // بنحسب الـ total محلياً عشان أضمن الدقة
    final calculatedTotal = items.fold<double>(0, (sum, e) => sum + e.totalPrice);

    return CartModel(
      id: data['_id']?.toString() ?? '',
      items: items,
      totalPrice: calculatedTotal,
    );
  }

  int get itemCount => items.fold(0, (sum, e) => sum + e.quantity);
}

// ─── Order Model ──────────────────────────────────────────────────────────────
class OrderModel {
  final String id;
  final String status;
  final double totalPrice;
  final String shippingAddress;
  final DateTime createdAt;
  final List<CartItemModel> items;

  OrderModel({
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.shippingAddress,
    required this.createdAt,
    required this.items,
  });

  // getMyOrders بيعمل map على الـ list مباشرةً، فكل element هو الـ order object
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final list = json['items'] as List? ?? [];
    final items =
        list.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>)).toList();

    final calculatedTotal = items.isNotEmpty
        ? items.fold<double>(0, (sum, e) => sum + e.totalPrice)
        : (json['total_amount'] ?? json['total_price'] ?? 0).toDouble();

    return OrderModel(
      id: json['_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      totalPrice: calculatedTotal,
      // الـ API بيبعت "shipping_address" مش "shippingAddress"
      shippingAddress: json['shipping_address']?.toString() ??
          json['shippingAddress']?.toString() ??
          '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      items: items,
    );
  }
}