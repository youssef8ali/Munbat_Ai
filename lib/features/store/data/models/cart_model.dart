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

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.treatmentId,
    required this.treatmentName, required this.discountedPrice, required this.discount, required this.status,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final treatment = json['treatment_id'];
    return ProductModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: (json['quantity'] ?? 0).toInt(),
      imageUrl: json['image_url']?.toString() ?? '',
      treatmentId: treatment is Map ? treatment['_id']?.toString() ?? '' : '',
      treatmentName:
          treatment is Map ? treatment['name']?.toString() ?? '' : '',
           discountedPrice:  (json['discountedPrice'] ?? json['price'] ?? 0).toDouble()
          , discount:(json['discount'] ?? 0).toInt(),
           status: json['status']?.toString() ?? 'in_stock',
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

// ─── Cart Item Model ──────────────────────────────────────────────────────────
class CartItemModel {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['productId'];
    return CartItemModel(
      productId: product is Map
          ? product['_id']?.toString() ?? ''
          : json['productId']?.toString() ?? '',
      name: product is Map ? product['name']?.toString() ?? '' : '',
      imageUrl: product is Map ? product['image_url']?.toString() ?? '' : '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: (json['quantity'] ?? 1).toInt(),
    );
  }

  double get totalPrice => price * quantity;
}

// ─── Cart Model ───────────────────────────────────────────────────────────────
class CartModel {
  final String id;
  final List<CartItemModel> items;
  final double totalPrice;

  CartModel({
    required this.id,
    required this.items,
    required this.totalPrice,
  });


factory CartModel.fromJson(Map<String, dynamic> json) {
  Map<String, dynamic> data = {};

  if (json['data'] != null) {
    final d = json['data'];

    if (d is Map<String, dynamic>) {
      // لو API راجع cart جوا data
      if (d['cart'] != null && d['cart'] is Map<String, dynamic>) {
        data = d['cart'];
      } else {
        data = d;
      }
    }
  } else {
    data = json;
  }

  final itemsRaw = data['items'] ?? [];

  return CartModel(
    id: data['_id']?.toString() ?? '',
    items: (itemsRaw as List)
        .map(
          (e) => CartItemModel.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList(),
    totalPrice: (data['total_price'] ??
            data['totalPrice'] ??
            0)
        .toDouble(),
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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final list = json['items'] as List? ?? [];
    return OrderModel(
      id: json['_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      shippingAddress: json['shippingAddress']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
              DateTime.now(),
      items: list
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}