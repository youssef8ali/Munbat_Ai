
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/core/utils/app_extensions.dart';
import 'package:munbat_ai/features/auth/presentation/pages/login_page.dart';
import 'package:munbat_ai/features/auth/presentation/pages/signup_page.dart';

/// Modern Buttons with glass morphism effect
class ModernWelcomeButtons extends StatelessWidget {
  const ModernWelcomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Login Button with modern style
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.push(LoginPage());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Log In',
                  style: AppTextStyles.button.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Sign Up Button with glass effect
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  AppColors.white.withOpacity(0.2),
                  AppColors.white.withOpacity(0.1),
                ],
              ),
              border: Border.all(
                color: AppColors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                context.push(SignUpPage());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign Up',
                    style: AppTextStyles.button.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.person_add_outlined,
                    size: 20,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: context.height * 0.1),
      ],
    );
  }
}
