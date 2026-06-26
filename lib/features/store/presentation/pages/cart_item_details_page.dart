// lib/features/store/presentation/pages/cart_item_details_page.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/store/data/models/store_models.dart';

class CartItemDetailsPage extends StatelessWidget {
  final CartItemModel item;

  const CartItemDetailsPage({super.key, required this.item});

  bool get _isOutOfStock => item.status?.toLowerCase() == 'out_of_stock';
  bool get _isLowStock => item.status?.toLowerCase() == 'low_stock';
  bool get _hasDiscount => item.originalPrice > item.price;

  Widget _buildStatusBadge() {
    Color color;
    String label;
    IconData icon;

    if (_isOutOfStock) {
      color = const Color(0xFFFF3B30);
      label = 'Out of Stock';
      icon = Icons.cancel_outlined;
    } else if (_isLowStock) {
      color = const Color(0xFFFF9500);
      label = 'Low Stock';
      icon = Icons.warning_amber_rounded;
    } else {
      color = const Color(0xFF34C759);
      label = 'In Stock';
      icon = Icons.check_circle_outline;
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Image ────────────────────────────────────────────
                  Stack(
                    children: [
                      SizedBox(
                        height: 340,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            item.imageUrl.isNotEmpty
                                ? Image.network(
                                    item.imageUrl,
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

                      // Badge فوق الصورة
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
                      else if (_hasDiscount)
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
                              '-${(((item.originalPrice - item.price) / item.originalPrice) * 100).round()}%',
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
                        // ─── Name ─────────────────────────────────────
                        Text(
                          item.name.isNotEmpty ? item.name : 'Product',
                          style: AppTextStyles.h1.copyWith(fontSize: 24),
                        ),

                        const SizedBox(height: 20),

                        // ─── Price ────────────────────────────────────
                        if (_isOutOfStock) ...[
                          Text(
                            '\$${item.originalPrice.toStringAsFixed(2)}',
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 30,
                            ),
                          ),
                        ] else if (_hasDiscount) ...[
                          Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.primary,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '\$${item.originalPrice.toStringAsFixed(2)}',
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
                                  'Save \$${(item.originalPrice - item.price).toStringAsFixed(2)}',
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
                            '\$${item.price.toStringAsFixed(2)}',
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.primary,
                              fontSize: 30,
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        _buildStatusBadge(),

                        const SizedBox(height: 20),

                        // ─── Quantity in Cart ─────────────────────────
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.shopping_cart_outlined,
                                  color: AppColors.primary),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Quantity in Cart',
                                      style: AppTextStyles.caption.copyWith(
                                          color: AppColors.textSecondary)),
                                  Text(
                                    '${item.quantity} item${item.quantity > 1 ? 's' : ''}',
                                    style: AppTextStyles.h3
                                        .copyWith(color: AppColors.primary),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Total',
                                      style: AppTextStyles.caption.copyWith(
                                          color: AppColors.textSecondary)),
                                  Text(
                                    '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                    style: AppTextStyles.h3
                                        .copyWith(color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Bottom Bar ───────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: AppColors.white),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isOutOfStock ? Colors.grey.shade400 : AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _isOutOfStock ? null : () => Navigator.pop(context),
                icon: Icon(
                  _isOutOfStock
                      ? Icons.remove_shopping_cart
                      : Icons.arrow_back,
                  color: Colors.white,
                ),
                label: Text(
                  _isOutOfStock ? 'Out of Stock' : 'Back to Cart',
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