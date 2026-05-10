// lib/features/diagnosis/presentation/widgets/diagnosis_title_row.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';

class DiagnosisTitleRow extends StatelessWidget {
  final String diseaseName;

  const DiagnosisTitleRow({
    super.key,
    required this.diseaseName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            diseaseName,
            style: AppTextStyles.h2,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {},
        ),
      ],
    );
  }
}