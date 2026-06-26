// lib/features/home/presentation/pages/search_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/core/utils/app_extensions.dart';
import 'package:munbat_ai/features/home/data/models/plant_model.dart';
import 'package:munbat_ai/features/home/data/repositories/catalog_repository.dart';
import 'package:munbat_ai/features/plant_details/presentation/pages/plant_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final CatalogRepository _repository = CatalogRepository();

  List<PlantModel> _results = [];
  bool _hasSearched = false;
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String query) {
    _debounce?.cancel();

    final q = query.trim();
    setState(() {
      _hasSearched = q.isNotEmpty;
      if (q.isEmpty) {
        _results = [];
        _isLoading = false;
      }
    });

    if (q.isEmpty) return;

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      setState(() => _isLoading = true);

      final results = await _repository.getAllPlants(search: q, limit: 20, page: 1);

      if (!mounted) return;
      setState(() {
        _results = results;
        _isLoading = false;
      });
    });
  }

  Color _statusColor(PlantStatus status) {
    switch (status) {
      case PlantStatus.healthy:
        return AppColors.primary;
      case PlantStatus.disease:
        return const Color(0xFFE74C3C);
      case PlantStatus.pest:
        return Colors.orange;
      case PlantStatus.notScanned:
        return AppColors.textSecondary;
    }
  }

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
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onSearch,
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search for a plant (e.g., Tomato)...',
            hintStyle: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
            border: InputBorder.none,
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear,
                        color: AppColors.textSecondary, size: 20),
                    onPressed: () {
                      _controller.clear();
                      _onSearch('');
                    },
                  )
                : null,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_hasSearched) {
      return _buildSuggestions();
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌱', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text('No plants found', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              'Try searching with a different name',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final plant = _results[index];
        return _PlantSearchCard(
          plant: plant,
          category: plant.categoryName ?? 'Plant',
          statusColor: _statusColor(plant.status),
          onTap: () => context.push(PlantDetailsPage(plant: plant)),
        );
      },
    );
  }

  Widget _buildSuggestions() {
    final suggestions = ['Apple', 'Banana', 'Orange'];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Popular Plants',
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: suggestions.map((s) {
              return GestureDetector(
                onTap: () {
                  _controller.text = s;
                  _onSearch(s);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🌿', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(s,
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─── Plant Search Card ────────────────────────────────────────────────────────
class _PlantSearchCard extends StatelessWidget {
  final PlantModel plant;
  final String category;
  final Color statusColor;
  final VoidCallback onTap;

  const _PlantSearchCard({
    required this.plant,
    required this.category,
    required this.statusColor,
    required this.onTap,
  });

  bool get _isNetwork =>
      plant.imageUrl.startsWith('http://') || plant.imageUrl.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: plant.imageUrl.isEmpty
                  ? Container(
                      width: 60,
                      height: 60,
                      color: AppColors.primary.withOpacity(0.1),
                      child: const Icon(Icons.eco,
                          color: AppColors.primary, size: 30),
                    )
                  : _isNetwork
                      ? Image.network(
                          plant.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: AppColors.primary.withOpacity(0.1),
                            child: const Icon(Icons.eco,
                                color: AppColors.primary, size: 30),
                          ),
                        )
                      : Image.asset(
                          plant.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: AppColors.primary.withOpacity(0.1),
                            child: const Icon(Icons.eco,
                                color: AppColors.primary, size: 30),
                          ),
                        ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plant.name,
                      style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  const SizedBox(height: 2),
                  if (plant.scientificName.isNotEmpty)
                    Text(plant.scientificName,
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(category,
                            style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(plant.statusText,
                          style: AppTextStyles.caption
                              .copyWith(color: statusColor)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}