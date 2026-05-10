
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/core/constants/app_constants.dart';

// Permission Denied View
class PermissionDeniedView extends StatelessWidget {
  final VoidCallback onOpenSettings;
  final VoidCallback onUseGallery;

  const PermissionDeniedView({
    super.key,
    required this.onOpenSettings,
    required this.onUseGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 80,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppConstants.paddingLarge),
            Text(
              'Camera Permission Required',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppConstants.paddingMedium),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingLarge,
              ),
              child: Text(
                'We need camera access to diagnose plant diseases. Please enable camera permission in settings.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: AppConstants.paddingLarge),
            ElevatedButton(
              onPressed: onOpenSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingLarge,
                  vertical: AppConstants.paddingMedium,
                ),
              ),
              child: Text(
                'Open Settings',
                style: AppTextStyles.button,
              ),
            ),
            SizedBox(height: AppConstants.paddingMedium),
            ElevatedButton(
              onPressed: onUseGallery,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingLarge,
                  vertical: AppConstants.paddingMedium,
                ),
              ),
              child: Text(
                'Use Gallery Instead',
                style: AppTextStyles.button,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
