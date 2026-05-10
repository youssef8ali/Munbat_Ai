
// Confirm Password Field Widget
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';

class ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final VoidCallback onVisibilityToggle;

  const ConfirmPasswordField({
    super.key,
    required this.controller,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !isPasswordVisible,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: 'Confirm Password',
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textHint,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.iconInactive,
          ),
          onPressed: onVisibilityToggle,
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
