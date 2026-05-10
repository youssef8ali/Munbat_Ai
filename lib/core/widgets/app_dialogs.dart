// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/core/constants/app_constants.dart';

// =====================================================
// INFO DIALOG
// =====================================================
void showInfoDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? buttonText,
  VoidCallback? onPressed,
}) {
  showDialog(
    context: context,
    builder: (context) => ModernDialog(
      type: DialogType.info,
      title: title,
      message: message,
      buttonText: buttonText ?? 'OK',
      onPressed: onPressed ?? () => Navigator.pop(context),
    ),
  );
}

// =====================================================
// ERROR DIALOG
// =====================================================
void showErrorDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? buttonText,
  VoidCallback? onPressed,
}) {
  showDialog(
    context: context,
    builder: (context) => ModernDialog(
      type: DialogType.error,
      title: title,
      message: message,
      buttonText: buttonText ?? 'Try Again',
      onPressed: onPressed ?? () => Navigator.pop(context),
    ),
  );
}

// =====================================================
// WARNING DIALOG
// =====================================================
void showWarningDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? primaryButtonText,
  String? secondaryButtonText,
  VoidCallback? onPrimaryPressed,
  VoidCallback? onSecondaryPressed,
}) {
  showDialog(
    context: context,
    builder: (context) => ModernDialog(
      type: DialogType.warning,
      title: title,
      message: message,
      buttonText: primaryButtonText ?? 'Continue',
      secondaryButtonText: secondaryButtonText ?? 'Cancel',
      onPressed: onPrimaryPressed ?? () => Navigator.pop(context),
      onSecondaryPressed: onSecondaryPressed ?? () => Navigator.pop(context),
    ),
  );
}

// =====================================================
// DIALOG TYPE ENUM
// =====================================================
enum DialogType { info, error, warning }

// =====================================================
// MODERN DIALOG WIDGET
// =====================================================
class ModernDialog extends StatelessWidget {
  final DialogType type;
  final String title;
  final String message;
  final String buttonText;
  final String? secondaryButtonText;
  final VoidCallback onPressed;
  final VoidCallback? onSecondaryPressed;

  const ModernDialog({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
  });

  
  Map<String, dynamic> _getTypeConfig() {
    switch (type) {
      case DialogType.info:
        return {
          'color': AppColors.primary,
          'lightColor': AppColors.primaryDark.withOpacity(0.1),
          'icon': Icons.info_outline,
          'gradient1': AppColors.primaryDark,
          'gradient2': AppColors.primary,
        };
      case DialogType.error:
        return {
          'color': AppColors.categoryDisease,
          'lightColor': AppColors.categoryDisease.withOpacity(0.1),
          'icon': Icons.error_outline,
          'gradient1': const Color(0xFFE74C3C),
          'gradient2': const Color(0xFFC0392B),
        };
      case DialogType.warning:
        return {
          'color': const Color(0xFFFFA500),
          'lightColor': const Color(0xFFFFA500).withOpacity(0.1),
          'icon': Icons.warning_amber,
          'gradient1': const Color(0xFFFFA500),
          'gradient2': const Color(0xFFFF8C00),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getTypeConfig();

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
          ),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [config['gradient1'], config['gradient2']],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        config['icon'],
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: AppConstants.paddingMedium),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.h2.copyWith(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    height: 1.5,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),

              // Buttons
              Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: secondaryButtonText != null
                    ? Row(
                        children: [
                          // Cancel button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: onSecondaryPressed,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                side: BorderSide(
                                  color: config['color'],
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                secondaryButtonText!,
                                style: AppTextStyles.button.copyWith(
                                  color: config['color'],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: AppConstants.paddingMedium),
                          // Primary button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: config['color'],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                buttonText,
                                style: AppTextStyles.button.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: config['color'],
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                type == DialogType.error
                                    ? Icons.refresh
                                    : Icons.check_circle,
                                size: 20,
                              ),
                              SizedBox(width: AppConstants.paddingSmall),
                              Text(
                                buttonText,
                                style: AppTextStyles.button.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}