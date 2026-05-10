// lib/features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/core/utils/app_extensions.dart';
import 'package:munbat_ai/features/home/data/datasoures/plants_data.dart';
import 'package:munbat_ai/features/home/data/models/plant_model.dart';
import 'package:munbat_ai/features/home/presentation/widgets/category_tabs_widget.dart';
import 'package:munbat_ai/features/home/presentation/widgets/header_widget.dart';
import 'package:munbat_ai/features/home/presentation/widgets/plant_grid_widget.dart';
import 'package:munbat_ai/features/plant_details/presentation/pages/plant_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'fruits';

  void _onCategoryChanged(String category) {
    setState(() => _selectedCategory = category);
  }

  void _onPlantTap(PlantModel plant) {
    context.push(PlantDetailsPage(plant: plant));
  }

  @override
  Widget build(BuildContext context) {
    final plants = PlantsData.getPlantsByCategory(_selectedCategory);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Find your plant', style: AppTextStyles.h2),
                    const SizedBox(height: 16),
                    CategoryTabsWidget(
                      selectedCategory: _selectedCategory,
                      onCategoryChanged: _onCategoryChanged,
                    ),
                    const SizedBox(height: 20),
                    PlantGridWidget(plants: plants, onPlantTap: _onPlantTap),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
