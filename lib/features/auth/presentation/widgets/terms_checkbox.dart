
// Terms Checkbox Widget
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';

class TermsCheckbox extends StatelessWidget {
  final bool agreeToTerms;
  final ValueChanged<bool> onAgreeToTermsChanged;

  const TermsCheckbox({
    super.key,
    required this.agreeToTerms,
    required this.onAgreeToTermsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: agreeToTerms,
            onChanged: (value) => onAgreeToTermsChanged(value ?? false),
            activeColor: AppColors.primary,
            side: const BorderSide(
              color: AppColors.greyLight,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Wrap(
            children: [
              Text(
                'I agree to the ',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to terms and conditions
                },
                child: Text(
                  'Terms and Conditions',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                ' and ',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to privacy policy
                },
                child: Text(
                  'Privacy Policy',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
