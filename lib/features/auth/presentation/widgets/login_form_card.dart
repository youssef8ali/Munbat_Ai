
// Login Form Card Widget
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/email_field.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/login_button.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/password_field.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/remember_forgot_row.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/signup_link.dart';

class LoginFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool keepMeSignedIn;
  final bool isLoading;
  final VoidCallback onPasswordVisibilityToggle;
  final ValueChanged<bool> onKeepMeSignedInChanged;
  final VoidCallback onLogin;

  const LoginFormCard({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.keepMeSignedIn,
    required this.isLoading,
    required this.onPasswordVisibilityToggle,
    required this.onKeepMeSignedInChanged,
    required this.onLogin,
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
              'Log In',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            EmailField(controller: emailController),
            const SizedBox(height: 16),
            PasswordField(
              controller: passwordController,
              isPasswordVisible: isPasswordVisible,
              onVisibilityToggle: onPasswordVisibilityToggle,
            ),
            const SizedBox(height: 16),
            RememberAndForgotRow(
              keepMeSignedIn: keepMeSignedIn,
              onKeepMeSignedInChanged: onKeepMeSignedInChanged,
            ),
            const SizedBox(height: 24),
            LoginButton(
              isLoading: isLoading,
              onPressed: onLogin,
            ),
            const SizedBox(height: 16),
            const SignUpLink(),
          ],
        ),
      ),
    );
  }
}
