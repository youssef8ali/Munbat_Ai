// lib/features/store/presentation/pages/cart_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';

import 'package:munbat_ai/features/store/data/repositories/store_repository.dart';
import 'package:munbat_ai/features/store/presentation/cubit/store_cubit.dart';
import 'package:munbat_ai/features/store/presentation/cubit/store_state.dart';
import 'package:munbat_ai/features/store/presentation/pages/checkout_page.dart';
import 'package:munbat_ai/features/store/presentation/pages/cart_item_details_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubitStore(StoreRepository())..loadCart(),
      child: const _CartView(),
    );
  }
}

class _CartView extends StatelessWidget {
  const _CartView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('My Cart',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubitStore, CartState>(
        builder: (context, state) {
          if (state is CartLoading || state is CartInitial) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is CartError) {
            return Center(
              child: Text(state.message,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary)),
            );
          }

          if (state is CartSuccess) {
            if (state.cart.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart_outlined,
                        size: 64, color: AppColors.textSecondary),
                    const SizedBox(height: 16),
                    Text('Your cart is empty', style: AppTextStyles.h2),
                    const SizedBox(height: 8),
                    Text('Add products from the store',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              );
            }

            // ─── حساب التوفير الكلي ───────────────────────────────
            final totalSaved = state.cart.items.fold<double>(0, (sum, item) {
              final original = item.originalPrice;
              return sum + ((original - item.price) * item.quantity);
            });

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: state.cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = state.cart.items[index];
                      return _CartItem(
                        key: ValueKey(item.productId),
                        item: item,
                        onDelete: () => context
                            .read<CartCubitStore>()
                            .removeItem(item.productId),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CartItemDetailsPage(item: item),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // ─── Summary + Checkout ───────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // ─── You Save banner ──────────────────────
                      if (totalSaved > 0)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.green.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.local_offer_rounded,
                                  color: Colors.green, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'You save \$${totalSaved.toStringAsFixed(2)} on this order!',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total',
                              style: AppTextStyles.h3.copyWith(fontSize: 18)),
                          Text(
                            '\$${state.cart.totalPrice.toStringAsFixed(2)}',
                            style: AppTextStyles.h2
                                .copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CheckoutPage()),
                            );
                            if (context.mounted) {
                              context.read<CartCubitStore>().loadCart();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Proceed to Checkout',
                            style: AppTextStyles.h3.copyWith(
                                color: AppColors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─── Cart Item with Delete Animation ─────────────────────────────────────────
class _CartItem extends StatefulWidget {
  final dynamic item;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _CartItem({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onTap,
  });

  @override
  State<_CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<_CartItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<Color?> _colorAnim;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _colorAnim =
        ColorTween(begin: Colors.red, end: Colors.red.shade900).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleDelete() async {
    if (_isDeleting) return;
    setState(() => _isDeleting = true);
    await _controller.forward();
    await _controller.reverse();
    await Future.delayed(const Duration(milliseconds: 100));
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final double originalPrice = item.originalPrice;
    final bool hasDiscount = originalPrice > item.price;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ─── Image + Discount Badge ─────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: item.imageUrl.isNotEmpty
                      ? Image.network(
                          item.imageUrl,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _imagePlaceholder(),
                        )
                      : _imagePlaceholder(),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        '-${(((originalPrice - item.price) / originalPrice) * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            // ─── Info ─────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name.isNotEmpty ? item.name : 'Product',
                    style: AppTextStyles.h3.copyWith(fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (item.status != null && item.status!.isNotEmpty)
                    _CartStatusBadge(status: item.status!),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Qty: ${item.quantity}',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.primary),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 5),
                        Text(
                          '\$${originalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // ─── Total + Delete ────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
                if (hasDiscount)
                  Text(
                    '\$${(originalPrice * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _handleDelete,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnim.value,
                        child: Icon(
                          _isDeleting
                              ? Icons.delete_rounded
                              : Icons.delete_outline,
                          color: _colorAnim.value,
                          size: 22,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 64,
      height: 64,
      color: const Color(0xFFF0FAF0),
      child: const Icon(Icons.eco, color: AppColors.primary, size: 32),
    );
  }
}

// ─── Status Badge ─────────────────────────────────────────────────────────────
class _CartStatusBadge extends StatelessWidget {
  final String status;
  const _CartStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'in_stock':
        color = const Color(0xFF34C759);
        label = 'In Stock';
        break;
      case 'low_stock':
        color = const Color(0xFFFF9500);
        label = 'Low Stock';
        break;
      case 'out_of_stock':
        color = const Color(0xFFFF3B30);
        label = 'Out of Stock';
        break;
      default:
        return const SizedBox.shrink();
    }

    return Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}