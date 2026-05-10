
// Treatment plan header with view full guide link
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';

class TreatmentPlanHeader extends StatelessWidget {
  const TreatmentPlanHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Treatment Plan',
          style: AppTextStyles.h3,
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'View Full Guide',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
