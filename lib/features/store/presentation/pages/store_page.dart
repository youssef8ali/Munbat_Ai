// lib/features/store/presentation/pages/store_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/store/data/models/store_models.dart';
import 'package:munbat_ai/features/store/data/repositories/store_repository.dart';
import 'package:munbat_ai/features/store/presentation/cubit/store_cubit.dart';
import 'package:munbat_ai/features/store/presentation/cubit/store_state.dart';
import 'package:munbat_ai/features/store/presentation/pages/cart_page.dart';
import 'package:munbat_ai/features/store/presentation/pages/product_details_page.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StoreCubit(StoreRepository())..loadStore(),
      child: const _StoreView(),
    );
  }
}

class _StoreView extends StatefulWidget {
  const _StoreView();

  @override
  State<_StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<_StoreView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<StoreCubit>().loadStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<StoreCubit, StoreState>(
          builder: (context, state) {
            return Column(
              children: [
                // ─── Search + Cart Row ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (q) =>
                                context.read<StoreCubit>().search(q),
                            decoration: InputDecoration(
                              hintText: 'Search treatments (e.g., Neem Oil)',
                              hintStyle: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.textSecondary),
                              prefixIcon: Icon(Icons.search,
                                  color: AppColors.textSecondary
                                      .withOpacity(0.6)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      BlocBuilder<StoreCubit, StoreState>(
                        builder: (context, state) {
                          final count =
                              state is StoreSuccess ? state.cartItemCount : 0;
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CartPage()),
                              );
                              if (context.mounted) {
                                context.read<StoreCubit>().refreshCart();
                              }
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(Icons.shopping_cart_outlined,
                                      color: AppColors.textPrimary, size: 22),
                                  if (count > 0)
                                    Positioned(
                                      right: 8,
                                      top: 8,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '$count',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                _buildCategoriesBar(context, state),
                Expanded(child: _buildBody(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoriesBar(BuildContext context, StoreState state) {
    if (state is! StoreSuccess || state.categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        itemCount: state.categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _CategoryChip(
              label: 'All',
              selected: state.selectedCategoryId == null,
              onTap: () => context.read<StoreCubit>().selectCategory(null),
            );
          }
          final category = state.categories[index - 1];
          return _CategoryChip(
            label: category.name,
            selected: state.selectedCategoryId == category.id,
            onTap: () =>
                context.read<StoreCubit>().selectCategory(category.id),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, StoreState state) {
    if (state is StoreLoading || state is StoreInitial) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (state is StoreError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                color: AppColors.textSecondary, size: 48),
            const SizedBox(height: 16),
            Text(state.message,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<StoreCubit>().loadStore(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary),
              child: const Text('Retry',
                  style: TextStyle(color: AppColors.white)),
            ),
          ],
        ),
      );
    }

    if (state is StoreSuccess) {
      if (state.products.isEmpty && !state.isLoadingProducts) {
        return Center(
          child: Text('No products found',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
        );
      }

      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => _onRefresh(context),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StoreBannerCarousel(),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'All Products (${state.totalProducts})',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: state.isLoadingProducts
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 80),
                        child: Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary),
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          final product = state.products[index];
                          final isOutOfStock =
                              product.status.toLowerCase() == 'out_of_stock';
                          return _ProductCard(
                            product: product,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailsPage(product: product),
                                ),
                              );
                              if (context.mounted) {
                                context.read<StoreCubit>().refreshCart();
                              }
                            },
                            onAddToCart: isOutOfStock
                                ? null
                                : () {
                                    context.read<StoreCubit>().addToCart(
                                          productId: product.id,
                                          price: product.discountedPrice,
                                        );
                                  },
                          );
                        },
                      ),
              ),

              // ─── Pagination ───────────────────────────────────────────
              if (!state.isLoadingProducts && state.totalPages > 1)
                _PaginationBar(
                  currentPage: state.currentPage,
                  totalPages: state.totalPages,
                  onPageChanged: (page) {
                    context.read<StoreCubit>().goToPage(page);
                    _scrollToTop();
                  },
                ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

// ─── Pagination Bar ───────────────────────────────────────────────────────────
class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  List<int?> _buildPages() {
    // null = "..."
    if (totalPages <= 7) {
      return List.generate(totalPages, (i) => i + 1);
    }

    final pages = <int?>[];

    if (currentPage <= 4) {
      pages.addAll([1, 2, 3, 4, 5, null, totalPages]);
    } else if (currentPage >= totalPages - 3) {
      pages.addAll([
        1,
        null,
        totalPages - 4,
        totalPages - 3,
        totalPages - 2,
        totalPages - 1,
        totalPages,
      ]);
    } else {
      pages.addAll([
        1,
        null,
        currentPage - 1,
        currentPage,
        currentPage + 1,
        null,
        totalPages,
      ]);
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // زرار السابق
          _NavButton(
            icon: Icons.chevron_left_rounded,
            enabled: currentPage > 1,
            onTap: () => onPageChanged(currentPage - 1),
          ),

          const SizedBox(width: 4),

          // أرقام الصفحات
          ...pages.map((page) {
            if (page == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('...', style: TextStyle(color: Colors.grey)),
              );
            }
            final isActive = page == currentPage;
            return GestureDetector(
              onTap: isActive ? null : () => onPageChanged(page),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                  border: isActive
                      ? null
                      : Border.all(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                ),
                child: Center(
                  child: Text(
                    '$page',
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(width: 4),

          // زرار التالي
          _NavButton(
            icon: Icons.chevron_right_rounded,
            enabled: currentPage < totalPages,
            onTap: () => onPageChanged(currentPage + 1),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled ? AppColors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.textPrimary : Colors.grey.shade400,
        ),
      ),
    );
  }
}

// ─── Store Banner Carousel ────────────────────────────────────────────────────
class StoreBannerCarousel extends StatefulWidget {
  const StoreBannerCarousel({super.key});

  @override
  State<StoreBannerCarousel> createState() => _StoreBannerCarouselState();
}

class _StoreBannerCarouselState extends State<StoreBannerCarousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<BannerSlide> _slides = [
    BannerSlide(
      badge: '🌿 PLANT CARE',
      title: 'Treatment Store',
      subtitle: 'Find the right treatment\nfor your plants.',
      gradientColors: [Color(0xFF2D5016), Color(0xFF4A7C2C)],
      icon: Icons.eco_outlined,
    ),
    BannerSlide(
      badge: '💧 NEW ARRIVALS',
      title: 'Irrigation Solutions',
      subtitle: 'Smart watering systems\nfor every garden size.',
      gradientColors: [Color(0xFF185FA5), Color(0xFF378ADD)],
      icon: Icons.water_drop_outlined,
    ),
    BannerSlide(
      badge: '⚡ BEST SELLERS',
      title: 'Top Fertilizers',
      subtitle: 'Boost your harvest with\nour premium nutrients.',
      gradientColors: [Color(0xFF854F0B), Color(0xFFEF9F27)],
      icon: Icons.grass_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      final next = (_currentPage + 1) % _slides.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 160,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _SlideItem(slide: _slides[i]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (i) {
            final isActive = i == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF4A7C2C)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _SlideItem extends StatelessWidget {
  final BannerSlide slide;
  const _SlideItem({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: slide.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            bottom: -8,
            child: Icon(slide.icon,
                size: 90, color: Colors.white.withOpacity(0.15)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  slide.badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                slide.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                slide.subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BannerSlide {
  final String badge;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final IconData icon;

  const BannerSlide({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.icon,
  });
}

// ─── Category Chip ────────────────────────────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.textSecondary.withOpacity(0.25),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: selected ? AppColors.white : AppColors.textPrimary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Product Card ─────────────────────────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;

  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFD97847),
      const Color(0xFF4A7C2C),
      const Color(0xFF2D5016),
      const Color(0xFFB88B6D),
      const Color(0xFF5B8A3C),
    ];
    final color = colors[product.id.hashCode % colors.length];
    final hasDiscount = product.discount > 0;
    final isOutOfStock = product.status.toLowerCase() == 'out_of_stock';

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isOutOfStock ? 0.6 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                      child: product.imageUrl.isNotEmpty
                          ? Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (_, __, ___) =>
                                  _buildPlaceholder(color),
                            )
                          : _buildPlaceholder(color),
                    ),
                    if (hasDiscount && !isOutOfStock)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-${product.discount}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    if (isOutOfStock)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Out of Stock',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.h3.copyWith(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _StatusBadge(status: product.status),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${product.discountedPrice.toStringAsFixed(2)}',
                              style: AppTextStyles.h3.copyWith(
                                fontSize: 15,
                                color: isOutOfStock
                                    ? AppColors.textSecondary
                                    : AppColors.primary,
                              ),
                            ),
                            if (hasDiscount && !isOutOfStock)
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                        _AnimatedAddButton(
                          onTap: onAddToCart,
                          disabled: isOutOfStock,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(Color color) {
    return Container(
      color: color.withOpacity(0.15),
      child: Center(child: Icon(Icons.eco, color: color, size: 40)),
    );
  }
}

// ─── Status Badge ─────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String? status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == null || status!.isEmpty) return const SizedBox.shrink();

    Color color;
    String label;
    IconData icon;

    switch (status!.toLowerCase()) {
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─── Animated Add Button ──────────────────────────────────────────────────────
class _AnimatedAddButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool disabled;
  const _AnimatedAddButton({required this.onTap, required this.disabled});

  @override
  State<_AnimatedAddButton> createState() => _AnimatedAddButtonState();
}

class _AnimatedAddButtonState extends State<_AnimatedAddButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _added = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1, end: 0.82).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.disabled || widget.onTap == null) return;
    await _controller.forward();
    await _controller.reverse();
    widget.onTap!();
    setState(() => _added = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _added = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.disabled ? null : _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: widget.disabled
                ? Colors.grey.shade400
                : (_added ? Colors.green : AppColors.primary),
            shape: BoxShape.circle,
            boxShadow: widget.disabled
                ? null
                : [
                    BoxShadow(
                      color: (_added ? Colors.green : AppColors.primary)
                          .withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: widget.disabled
              ? const Icon(Icons.block, color: Colors.white, size: 16)
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: _added
                      ? const Icon(Icons.shopping_cart_checkout,
                          key: ValueKey('cart'),
                          color: Colors.white,
                          size: 16)
                      : const Icon(Icons.add,
                          key: ValueKey('add'),
                          color: Colors.white,
                          size: 16),
                ),
        ),
      ),
    );
  }
}