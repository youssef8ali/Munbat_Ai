// Instruction text
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/constants/app_constants.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';

class CameraInstructionText extends StatelessWidget {
  const CameraInstructionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingLarge,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Text(
        'Align leaf within frame for diagnosis',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textWhite,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
