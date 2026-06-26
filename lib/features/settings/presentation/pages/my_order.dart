// lib/features/settings/presentation/pages/my_order.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/store/data/models/store_models.dart';
import 'package:munbat_ai/features/store/data/repositories/store_repository.dart';
import 'package:munbat_ai/features/store/presentation/cubit/store_cubit.dart';
import 'package:munbat_ai/features/store/presentation/cubit/store_state.dart';

class MyOrderPage extends StatelessWidget {
  const MyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderCubit(StoreRepository())..loadOrders(),
      child: const _MyOrderView(),
    );
  }
}

class _MyOrderView extends StatefulWidget {
  const _MyOrderView();

  @override
  State<_MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends State<_MyOrderView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_TabConfig> _tabs = [
    _TabConfig(
      label: 'Active',
      icon: Icons.hourglass_top_rounded,
      statuses: ['pending', 'processing', 'shipped'],
      color: const Color(0xFFFF9500),
    ),
    _TabConfig(
      label: 'Delivered',
      icon: Icons.check_circle_rounded,
      statuses: ['delivered'],
      color: const Color(0xFF34C759),
    ),
    _TabConfig(
      label: 'Cancelled',
      icon: Icons.cancel_rounded,
      statuses: ['cancelled'],
      color: const Color(0xFFFF3B30),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<OrderModel> _filterOrders(List<OrderModel> orders, _TabConfig tab) {
    return orders
        .where((o) => tab.statuses.contains(o.status.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Orders',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
  const _RefreshButton(),
],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              unselectedLabelStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              tabs: _tabs
                  .map((t) => Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(t.icon, size: 16),
                            const SizedBox(width: 6),
                            Text(t.label),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading || state is OrderInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is OrderError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.error_outline,
                        color: Colors.red, size: 48),
                  ),
                  const SizedBox(height: 16),
                  Text(state.message,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<OrderCubit>().loadOrders(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text('Retry',
                        style: TextStyle(color: AppColors.white)),
                  ),
                ],
              ),
            );
          }

          if (state is OrderSuccess) {
            return TabBarView(
              controller: _tabController,
              children: _tabs.map((tab) {
                final filtered = _filterOrders(state.orders, tab);

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: tab.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(tab.icon, size: 48, color: tab.color),
                        ),
                        const SizedBox(height: 20),
                        Text('No ${tab.label} Orders', style: AppTextStyles.h2),
                        const SizedBox(height: 8),
                        Text(
                          tab.label == 'Active'
                              ? 'Orders in progress will appear here'
                              : tab.label == 'Delivered'
                                  ? 'Completed orders will appear here'
                                  : 'Cancelled orders will appear here',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _OrderCard(order: filtered[index]);
                  },
                );
              }).toList(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─── Tab Config ───────────────────────────────────────────────────────────────
class _TabConfig {
  final String label;
  final IconData icon;
  final List<String> statuses;
  final Color color;

  const _TabConfig({
    required this.label,
    required this.icon,
    required this.statuses,
    required this.color,
  });
}

// ─── Order Card ───────────────────────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return const Color(0xFF34C759);
      case 'shipped':
        return const Color(0xFF007AFF);
      case 'processing':
        return const Color(0xFF8E8E93);
      case 'pending':
        return const Color(0xFFFF9500);
      case 'cancelled':
        return const Color(0xFFFF3B30);
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle_rounded;
      case 'shipped':
        return Icons.local_shipping_rounded;
      case 'processing':
        return Icons.settings_rounded;
      case 'pending':
        return Icons.hourglass_top_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(order.status);
    final statusIcon = _statusIcon(order.status);

    return GestureDetector(
      onTap: () => _showDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ─── Header ───────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.05),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id.substring(order.id.length > 6 ? order.id.length - 6 : 0)}',
                          style: AppTextStyles.h3.copyWith(fontSize: 15),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(order.createdAt),
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Body ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (order.shippingAddress.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            order.shippingAddress,
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.shopping_bag_outlined,
                              size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Text(
                            '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Total  ',
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.textSecondary),
                          ),
                          Text(
                            '\$${order.totalPrice.toStringAsFixed(2)}',
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // View Details button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _showDetails(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: AppColors.primary.withOpacity(0.4)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text(
                        'View Details',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child:
                            Text('Order Details', style: AppTextStyles.h2),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          'Order #${order.id.substring(order.id.length > 6 ? order.id.length - 6 : 0)}',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (order.items.isEmpty)
                        Center(
                          child: Text(
                            'No item details available',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        )
                      else
                        ...order.items.map((item) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F7FA),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  // ─── Product Image ───
                                 Stack(
  children: [
    ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: item.imageUrl.isNotEmpty
          ? Image.network(
              item.imageUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
            )
          : _placeholder(),
    ),
    if (item.originalPrice > item.price)
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 4, vertical: 2),
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomRight: Radius.circular(6),
            ),
          ),
          child: Text(
            '-${(((item.originalPrice - item.price) / item.originalPrice) * 100).round()}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
  ],
),
                                  const SizedBox(width: 12),

                                  // ─── Name + Stock Status ───
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name.isNotEmpty
                                              ? item.name
                                              : 'Product',
                                          style: AppTextStyles.bodyMedium,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),

                                        // ─── Stock Status Badge ───
                                       if (item.status != null)
  Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: item.status == 'in_stock'
          ? const Color(0xFF34C759).withOpacity(0.12)
          : item.status == 'low_stock'
              ? const Color(0xFFFF9500).withOpacity(0.12)
              : const Color(0xFFFF3B30).withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      item.status == 'in_stock'
          ? 'In Stock'
          : item.status == 'low_stock'
              ? 'Low Stock'
              : 'Out of Stock',
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: item.status == 'in_stock'
            ? const Color(0xFF34C759)
            : item.status == 'low_stock'
                ? const Color(0xFFFF9500)
                : const Color(0xFFFF3B30),
      ),
    ),
  ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // ─── Quantity + Price ───
                                 // ─── Quantity + Price ───
Column(
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    Text(
      'x${item.quantity}',
      style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary),
    ),
    const SizedBox(height: 4),
    // السعر بعد الخصم
    Text(
      '\$${item.price.toStringAsFixed(2)}',
      style: AppTextStyles.h3.copyWith(
        fontSize: 14,
        color: AppColors.primary,
      ),
    ),
    // السعر الأصلي مشطوب لو فيه خصم
    if (item.originalPrice > item.price)
      Text(
        '\$${item.originalPrice.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 11,
          color: Colors.grey,
          decoration: TextDecoration.lineThrough,
          decorationColor: Colors.grey,
        ),
      ),
  ],
),
                                ],
                              ),
                            )),

                      const SizedBox(height: 8),

                      // ─── Total ───
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Amount', style: AppTextStyles.h3),
                            Text(
                              '\$${order.totalPrice.toStringAsFixed(2)}',
                              style: AppTextStyles.h2
                                  .copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.eco, color: AppColors.primary, size: 22),
    );
  }
}
// ─── Refresh Button (with rotation animation) ──────────────────────────────
class _RefreshButton extends StatefulWidget {
  const _RefreshButton();

  @override
  State<_RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<_RefreshButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleRefresh() {
    if (_controller.isAnimating) return;
    _controller.repeat();
    context.read<OrderCubit>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderSuccess || state is OrderError) {
          _controller
            ..stop()
            ..reset();
        }
      },
      child: RotationTransition(
        turns: _controller,
        child: IconButton(
          icon: const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
          tooltip: 'Refresh',
          onPressed: _handleRefresh,
        ),
      ),
    );
  }
}