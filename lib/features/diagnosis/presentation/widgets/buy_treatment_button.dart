
// Buy treatment button
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/constants/app_constants.dart';
import 'package:munbat_ai/core/theme/app_color.dart' show AppColors;
import 'package:munbat_ai/core/theme/app_text_styles.dart';

class BuyTreatmentButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BuyTreatmentButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.radiusLarge,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag),
            SizedBox(width: AppConstants.paddingSmall),
            Text(
              'Buy Treatment',
              style: AppTextStyles.button,
            ),
          ],
        ),
      ),
    );
  }
}