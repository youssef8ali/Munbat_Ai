// lib/features/diagnosis/presentation/widgets/diagnosis_badge_row.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/constants/app_constants.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';

class DiagnosisBadgeRow extends StatelessWidget {
  final bool isHealthy;
  final int diseaseCount;
  // ✅ confidence اختياري — مش موجود في الـ API response
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

    return Row(
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

        SizedBox(width: AppConstants.paddingMedium),

        // عدد الأمراض لو في أكتر من مرض
        if (!isHealthy && diseaseCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.bug_report,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                SizedBox(width: AppConstants.paddingSmall),
                Text(
                  '$diseaseCount ${diseaseCount == 1 ? 'Disease' : 'Diseases'}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
      ],
    );
  }
}