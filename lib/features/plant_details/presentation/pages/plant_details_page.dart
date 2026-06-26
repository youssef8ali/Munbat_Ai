// lib/features/plant_details/presentation/pages/plant_details_page.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/constants/app_icons.dart';
import 'package:munbat_ai/core/services/api_service.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/core/utils/app_extensions.dart';
import 'package:munbat_ai/core/widgets/svg_icon.dart';
import 'package:munbat_ai/features/articles/data/datasources/article_remote_datasource.dart';
import 'package:munbat_ai/features/articles/data/models/article_model.dart';
import 'package:munbat_ai/features/articles/data/repositories/article_repository.dart';
import 'package:munbat_ai/features/diagnosis/presentation/pages/camera_page.dart';
import 'package:munbat_ai/features/home/data/models/plant_model.dart';
import 'package:munbat_ai/features/plant_details/presentation/widgets/article_card_widget.dart';
import 'package:munbat_ai/features/plant_details/presentation/widgets/camera_banner_widget.dart';

class PlantDetailsPage extends StatefulWidget {
  final PlantModel plant;

  const PlantDetailsPage({super.key, required this.plant});

  @override
  State<PlantDetailsPage> createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetailsPage> {
  List<ArticleModel> _articles = [];
  bool _loadingArticles = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    try {
      // ignore: avoid_print
      print('🌱 PLANT ID => ${widget.plant.id}');
      final repo = ArticleRepository(
        dataSource: ArticleRemoteDataSource(),
      );
      final articles = await repo.getArticlesForPlant(widget.plant.id);
      // ignore: avoid_print
      print('📰 ARTICLES COUNT => ${articles.length}');
      if (mounted) setState(() => _articles = articles);
    } catch (e, stack) {
      // ignore: avoid_print
      print('❌ ARTICLES ERROR => $e');
      // ignore: avoid_print
      print('❌ STACK => $stack');
    } finally {
      if (mounted) setState(() => _loadingArticles = false);
    }
  }

  Color _getStatusColor(PlantStatus status) {
    switch (status) {
      case PlantStatus.healthy:
        return AppColors.primary;
      case PlantStatus.disease:
      case PlantStatus.pest:
        return AppColors.categoryDisease;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusIcon(PlantStatus status) {
    switch (status) {
      case PlantStatus.healthy:
        return AppIcons.checkMark;
      case PlantStatus.disease:
        return AppIcons.warning;
      case PlantStatus.pest:
        return AppIcons.bug;
      default:
        return AppIcons.cameraMinimalistic;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: widget.plant.imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: widget.plant.imageUrl.startsWith('http')
                              ? NetworkImage(widget.plant.imageUrl)
                              : AssetImage(widget.plant.imageUrl)
                                  as ImageProvider,
                          fit: BoxFit.cover,
                          onError: (_, __) {},
                        )
                      : null,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(widget.plant.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: SvgIcon(
                            assetPath: _getStatusIcon(widget.plant.status),
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.plant.statusText,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plant Info
                Container(
                  color: AppColors.white,
                  width: context.width,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.plant.name, style: AppTextStyles.h1),
                      const SizedBox(height: 8),
                      Text(
                        widget.plant.scientificName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Camera Banner
                CameraBannerWidget(
                  onCameraPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Opening camera to scan ${widget.plant.name}...'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                    context.push(CameraPage());
                  },
                ),

                const SizedBox(height: 24),

                // Articles Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Related Articles', style: AppTextStyles.h2),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See All',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Articles List
                if (_loadingArticles)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    ),
                  )
                else if (_articles.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 32),
                    child: Center(
                      child: Text(
                        'No articles available',
                        style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _articles.length,
                    itemBuilder: (context, index) =>
                        ArticleCardWidget(article: _articles[index]),
                  ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(CameraPage()),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.camera_alt, color: AppColors.white),
        label: const Text(
          'Scan Plant',
          style:
              TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}