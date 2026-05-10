// lib/features/home/presentation/widgets/plant_info_container.dart
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/core/widgets/svg_icon.dart';

class PlantInfoContainer extends StatelessWidget {
  final String name;
  final String scientificName;
  final String statusText;
  final Color statusColor;
  final String statusIcon;

  const PlantInfoContainer({
    super.key,
    required this.name,
    required this.scientificName,
    required this.statusText,
    required this.statusColor,
    required this.statusIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppTextStyles.h3.copyWith(fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            scientificName,
            style: AppTextStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: SvgIcon(assetPath: statusIcon , color: statusColor,)),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  statusText,
                  style: AppTextStyles.caption.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
