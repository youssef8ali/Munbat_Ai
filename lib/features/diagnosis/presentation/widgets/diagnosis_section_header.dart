
// Diagnosis section header
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';

class DiagnosisSectionHeader extends StatelessWidget {
  const DiagnosisSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'DIAGNOSIS',
      style: AppTextStyles.h4.copyWith(
        color: AppColors.textSecondary,
        fontSize: 12,
      ),
    );
  }
}
