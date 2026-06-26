// lib/features/store/presentation/pages/product_details_page.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/store/data/models/store_models.dart';
import 'package:munbat_ai/features/store/data/repositories/store_repository.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final StoreRepository _repo = StoreRepository();
  bool _isAddingToCart = false;

  bool get _isOutOfStock =>
      widget.product.status.toLowerCase() == 'out_of_stock';

  Future<void> _addToCart() async {
    if (_isOutOfStock) return;
    setState(() => _isAddingToCart = true);

    final cart = await _repo.addToCart(
      productId: widget.product.id,
      quantity: 1,
      price: widget.product.discountedPrice,
    );

    if (!mounted) return;
    setState(() => _isAddingToCart = false);

    if (cart != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to cart successfully'),
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 1),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add to cart'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'in_stock':
        color = const Color(0xFF34C759);
        label = 'In Stock';
        icon = Icons.check_circle_outline;
        break;
      case 'low_stock':
        color = const Color(0xFFFF9500);
        label = 'Low Stock';
        icon = Icons.warning_amber_rounded;
        break;
      case 'out_of_stock':
        color = const Color(0xFFFF3B30);
        label = 'Out of Stock';
        icon = Icons.cancel_outlined;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final hasDiscount = product.discount > 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Image + Badges ───────────────────────────────────
                  Stack(
                    children: [
                      // إذا out_of_stock نضيف overlay رمادي على الصورة
                      SizedBox(
                        height: 340,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            product.imageUrl.isNotEmpty
                                ? Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _buildImagePlaceholder(),
                                  )
                                : _buildImagePlaceholder(),
                            if (_isOutOfStock)
                              Container(
                                color: Colors.black.withOpacity(0.35),
                              ),
                          ],
                        ),
                      ),

                      // Back Button
                      Positioned(
                        top: 40,
                        left: 16,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: AppColors.textPrimary),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),

                      // Out of Stock badge على الصورة
                      if (_isOutOfStock)
                        Positioned(
                          top: 40,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade700,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Out of Stock',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        )
                      // Discount badge لو مش out_of_stock
                      else if (hasDiscount)
                        Positioned(
                          top: 40,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              '-${product.discount}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: AppTextStyles.h1.copyWith(fontSize: 24),
                        ),

                        const SizedBox(height: 12),

                        if (product.treatmentName.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product.treatmentName,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),

                        // ─── Price Section ─────────────────────────────
                        if (_isOutOfStock) ...[
                          // لو out_of_stock السعر بيبقى رمادي
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 30,
                            ),
                          ),
                        ] else if (hasDiscount) ...[
                          Text(
                            '\$${product.discountedPrice.toStringAsFixed(2)}',
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.primary,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Save \$${(product.price - product.discountedPrice).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.primary,
                              fontSize: 30,
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        if (product.status.isNotEmpty)
                          _buildStatusBadge(product.status),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              color: _isOutOfStock
                                  ? AppColors.textSecondary
                                  : AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Available Quantity: ${product.quantity}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: _isOutOfStock
                                    ? AppColors.textSecondary
                                    : null,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Text('Description', style: AppTextStyles.h2),
                        const SizedBox(height: 12),
                        Text(
                          product.description,
                          style: AppTextStyles.bodyMedium.copyWith(
                            height: 1.6,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Add to Cart Button ───────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: AppColors.white),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isOutOfStock
                      ? Colors.grey.shade400
                      : AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                // لو out_of_stock الزرار بيتعطل تماماً
                onPressed: (_isAddingToCart || _isOutOfStock) ? null : _addToCart,
                icon: _isAddingToCart
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Icon(
                        _isOutOfStock
                            ? Icons.remove_shopping_cart
                            : Icons.shopping_cart,
                        color: Colors.white,
                      ),
                label: Text(
                  _isAddingToCart
                      ? 'Adding...'
                      : _isOutOfStock
                          ? 'Out of Stock'
                          : 'Add To Cart',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.eco, size: 80, color: AppColors.primary),
      ),
    );
  }
}