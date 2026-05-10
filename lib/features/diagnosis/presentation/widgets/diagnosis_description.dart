// lib/features/diagnosis/presentation/widgets/diagnosis_description.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';

class DiagnosisDescription extends StatelessWidget {
  final String description;

  const DiagnosisDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: AppTextStyles.bodyMedium,
    );
  }
}