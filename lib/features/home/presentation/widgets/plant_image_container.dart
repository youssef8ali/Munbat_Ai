// lib/features/home/presentation/widgets/plant_image_container.dart
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/features/home/data/models/plant_model.dart';
import 'package:munbat_ai/features/home/presentation/widgets/status_badge.dart';

class PlantImageContainer extends StatelessWidget {
  final String imageUrl;
  final PlantStatus status;
  final Color statusColor;
  final String statusIcon;

  const PlantImageContainer({
    super.key,
    required this.imageUrl,
    required this.status,
    required this.statusColor,
    required this.statusIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imageUrl),fit: BoxFit.cover),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.greyLight.withOpacity(0.3),
            AppColors.greyLight.withOpacity(0.5),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),

      ),
      child: Stack(
        children: [
          Positioned(
            top: 12,
            right: 12,
            child: StatusBadge(
              statusColor: statusColor,
              statusIcon: statusIcon,
            ),
          ),
        ],
      ),
    );
  }
}