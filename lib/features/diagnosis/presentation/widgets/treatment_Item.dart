import 'package:flutter/material.dart';
import 'package:munbat_ai/core/constants/app_constants.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';

class TreatmentItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const TreatmentItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon container
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        SizedBox(width: AppConstants.paddingMedium),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.h4,
              ),
              SizedBox(height: AppConstants.paddingSmall),
              Text(
                description,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
