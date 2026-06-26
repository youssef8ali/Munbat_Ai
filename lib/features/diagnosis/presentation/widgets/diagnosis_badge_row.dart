// lib/features/diagnosis/presentation/widgets/diagnosis_badge_row.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/constants/app_constants.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';

class DiagnosisBadgeRow extends StatelessWidget {
  final bool isHealthy;
  final int diseaseCount;
  final double? confidence;

  const DiagnosisBadgeRow({
    super.key,
    required this.isHealthy,
    this.diseaseCount = 0,
    this.confidence,
  });

 @override
Widget build(BuildContext context) {
  final color = isHealthy ? AppColors.primary : AppColors.categoryDisease;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Status badge
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isHealthy ? Icons.check_circle : Icons.warning_rounded,
              color: color,
              size: 20,
            ),
            SizedBox(width: AppConstants.paddingSmall),
            Text(
              isHealthy ? 'Healthy' : 'Disease Detected',
              style: AppTextStyles.categoryLabel.copyWith(color: color),
            ),
          ],
        ),
      ),

      // عدد الأمراض في سطر تاني
      if (!isHealthy && diseaseCount > 0) ...[
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bug_report, color: AppColors.textSecondary, size: 18),
            const SizedBox(width: 4),
            Text(
              '$diseaseCount ${diseaseCount == 1 ? 'Disease' : 'Diseases'} Detected',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ],
    ],
  );
}
}