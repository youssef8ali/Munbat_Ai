// lib/features/home/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/core/utils/app_extensions.dart';
import 'package:munbat_ai/features/home/data/models/plant_model.dart';
import 'package:munbat_ai/features/home/data/repositories/catalog_repository.dart';
import 'package:munbat_ai/features/home/presentation/cubit/catalog_cubit.dart';
import 'package:munbat_ai/features/home/presentation/cubit/catalog_state.dart';
import 'package:munbat_ai/features/home/presentation/widgets/category_tabs_widget.dart';
import 'package:munbat_ai/features/home/presentation/widgets/header_widget.dart';
import 'package:munbat_ai/features/home/presentation/widgets/plant_grid_widget.dart';
import 'package:munbat_ai/features/plant_details/presentation/pages/plant_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CatalogCubit(CatalogRepository())..loadCategories(),
      child: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatelessWidget {
  const _HomePageView();

  void _onPlantTap(BuildContext context, PlantModel plant) {
    context.push(PlantDetailsPage(plant: plant));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(),
            Expanded(
              child: BlocBuilder<CatalogCubit, CatalogState>(
                builder: (context, state) {
                  if (state is CatalogInitial || state is CatalogLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (state is CatalogError) {
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
                            onPressed: () =>
                                context.read<CatalogCubit>().loadCategories(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary),
                            child: const Text('Retry',
                                style: TextStyle(color: AppColors.white)),
                          ),
                        ],
                      ),
                    );
                  }

                  final loaded = state as CatalogLoaded;

                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => context.read<CatalogCubit>().refresh(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _ScanBanner(),
                          const SizedBox(height: 14),
                          Text('Find your plant', style: AppTextStyles.h2),
                          const SizedBox(height: 10),
                          CategoryTabsWidget(
                            categories: loaded.categories,
                            selectedCategoryId: loaded.selectedCategoryId,
                            onCategoryChanged: (categoryId) {
                              context
                                  .read<CatalogCubit>()
                                  .selectCategory(categoryId);
                            },
                          ),
                          const SizedBox(height: 14),
                          if (loaded.isLoadingPlants)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: CircularProgressIndicator(
                                    color: AppColors.primary),
                              ),
                            )
                          else if (loaded.plants.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Text('No plants in this category',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary)),
                              ),
                            )
                          else
                            PlantGridWidget(
                              plants: loaded.plants,
                              onPlantTap: (plant) => _onPlantTap(context, plant),
                            ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Animated Scan Banner ─────────────────────────────────────────────────────
class _ScanBanner extends StatefulWidget {
  const _ScanBanner();

  @override
  State<_ScanBanner> createState() => _ScanBannerState();
}

class _ScanBannerState extends State<_ScanBanner>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late AnimationController _floatController;

  late Animation<double> _pulseAnim;
  late Animation<double> _shimmerAnim;
  late Animation<double> _floatAnim;

  final List<String> _hints = [
    'Is your plant healthy? 🌿',
    'Spot a disease early 🔍',
    'Get treatment instantly 💊',
    'Scan any leaf or fruit 🍃',
  ];
  int _hintIndex = 0;
  bool _hintVisible = true;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _rotateHints();
  }

  void _rotateHints() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 2500));
      if (!mounted) break;
      setState(() => _hintVisible = false);
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) break;
      setState(() {
        _hintIndex = (_hintIndex + 1) % _hints.length;
        _hintVisible = true;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3D10), Color(0xFF3A6B20), Color(0xFF4A8828)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3A6B20).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: Listenable.merge(
                [_pulseController, _shimmerController, _floatController]),
            builder: (context, _) {
              return Transform.translate(
                offset: Offset(0, _floatAnim.value),
                child: ScaleTransition(
                  scale: _pulseAnim,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                      ),
                      ClipOval(
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Transform.translate(
                                  offset: Offset(
                                    _shimmerAnim.value * 80,
                                    0,
                                  ),
                                  child: Container(
                                    width: 30,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.white.withOpacity(0.6),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Center(
                                child: Text(
                                  '🌿',
                                  style: TextStyle(fontSize: 26),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Scan Your Plant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedOpacity(
                  opacity: _hintVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedSlide(
                    offset: _hintVisible ? Offset.zero : const Offset(0, 0.3),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    child: Text(
                      _hints[_hintIndex],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Navigate to camera page
                    // context.push(CameraPage());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.qr_code_scanner,
                            color: AppColors.primary, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Scan Now',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}