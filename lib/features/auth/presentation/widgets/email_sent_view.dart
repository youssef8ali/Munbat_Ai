
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';

/// Email Sent Success View Widget
class EmailSentView extends StatelessWidget {
  final String email;
  final bool isLoading;
  final VoidCallback onResend;
  final VoidCallback onBackToLogin;

  const EmailSentView({
    super.key,
    required this.email,
    required this.isLoading,
    required this.onResend,
    required this.onBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        
        // Success Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mark_email_read_outlined,
            size: 50,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 32),
        
        Text(
          'Check Your Email',
          style: AppTextStyles.h1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        
        Text(
          'We\'ve sent a password reset link to',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        
        Text(
          email,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        
        Text(
          'Please check your inbox and click on the link to reset your password.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        
        // Back to Login Button
        ElevatedButton(
          onPressed: onBackToLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            'Back to Login',
            style: AppTextStyles.button.copyWith(
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Resend Email Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Didn\'t receive the email?  ',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: isLoading ? null : onResend,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Resend',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}