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
  // plant_info_container.dart
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // قلّلنا الـ padding
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // يأخذ أقل مساحة ممكنة
      children: [
        Text(
          name,
          style: AppTextStyles.h3.copyWith(fontSize: 13), // أصغر شوي
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          scientificName,
          style: AppTextStyles.caption.copyWith(fontSize: 11), // أصغر شوي
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            SizedBox(
              width: 14, // أصغر من 18
              height: 14,
              child: SvgIcon(assetPath: statusIcon, color: statusColor),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                statusText,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 11,
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
