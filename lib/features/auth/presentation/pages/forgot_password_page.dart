// lib/features/auth/presentation/pages/forgot_password_page.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:munbat_ai/features/auth/presentation/pages/reset_password_page.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/email_sent_view.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/forgot_password_form.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authRepository = AuthRepository();

  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await _authRepository.forgotPassword(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      // ✅ نعرض شاشة "Check Your Email"
      setState(() => _emailSent = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Something went wrong'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleResendEmail() async {
    setState(() => _isLoading = true);

    final result = await _authRepository.forgotPassword(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Reset link resent'),
        backgroundColor: result.success ? Colors.green : Colors.red,
      ),
    );
  }

  void _goToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _emailSent
              ? EmailSentView(
                  email: _emailController.text,
                  isLoading: _isLoading,
                  onResend: _handleResendEmail,
                  // ✅ زر "Enter Reset Code" بدل Back to Login عشان يكمل الـ flow
                  onBackToLogin: _goToResetPassword,
                )
              : ForgotPasswordForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  isLoading: _isLoading,
                  onResetPassword: _handleResetPassword,
                ),
        ),
      ),
    );
  }
}