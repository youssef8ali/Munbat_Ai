// lib/features/home/presentation/widgets/plant_card_widget.dart
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/constants/app_icons.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/features/home/data/models/plant_model.dart';
import 'package:munbat_ai/features/home/presentation/widgets/plant_image_container.dart';
import 'package:munbat_ai/features/home/presentation/widgets/plant_info_container.dart';


class PlantCardWidget extends StatelessWidget {
  final PlantModel plant;
  final VoidCallback onTap;

  const PlantCardWidget({super.key, required this.plant, required this.onTap});

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
    return GestureDetector(
      onTap: onTap,
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
              child: PlantImageContainer(
                imageUrl: plant.imageUrl,
                status: plant.status,
                statusColor: _getStatusColor(plant.status),
                statusIcon: _getStatusIcon(plant.status),
              ),
            ),
            PlantInfoContainer(
              name: plant.name,
              scientificName: plant.scientificName,
              statusText: plant.statusText,
              statusColor: _getStatusColor(plant.status),
              statusIcon: _getStatusIcon(plant.status),
            ),
          ],
        ),
      ),
    );
  }
}
