
// Sign Up Form Card Widget
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/confirm_password_field.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/email_field.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/login_link.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/name_field.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/password_field.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/signup_button.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/terms_checkbox.dart';

class SignUpFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool agreeToTerms;
  final bool isLoading;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onConfirmPasswordVisibilityToggle;
  final ValueChanged<bool> onAgreeToTermsChanged;
  final VoidCallback onSignUp;

  const SignUpFormCard({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.agreeToTerms,
    required this.isLoading,
    required this.onPasswordVisibilityToggle,
    required this.onConfirmPasswordVisibilityToggle,
    required this.onAgreeToTermsChanged,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create Account',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            NameField(controller: nameController),
            const SizedBox(height: 16),
            EmailField(controller: emailController),
            const SizedBox(height: 16),
            PasswordField(
              controller: passwordController,
              isPasswordVisible: isPasswordVisible,
              onVisibilityToggle: onPasswordVisibilityToggle,
            ),
            const SizedBox(height: 16),
            ConfirmPasswordField(
              controller: confirmPasswordController,
              passwordController: passwordController,
              isPasswordVisible: isConfirmPasswordVisible,
              onVisibilityToggle: onConfirmPasswordVisibilityToggle,
            ),
            const SizedBox(height: 16),
            TermsCheckbox(
              agreeToTerms: agreeToTerms,
              onAgreeToTermsChanged: onAgreeToTermsChanged,
            ),
            const SizedBox(height: 24),
            SignUpButton(
              isLoading: isLoading,
              onPressed: onSignUp,
            ),
            const SizedBox(height: 16),
            const LoginLink(),
          ],
        ),
      ),
    );
  }
}
