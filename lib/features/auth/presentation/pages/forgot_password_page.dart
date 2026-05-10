import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/email_sent_view.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/forgot_password_form.dart';
 
// ملاحظة: الباك الحالي مش عنده endpoint لـ forgot password
// لما يضيفوا الـ endpoint هتضيفه في ApiService و AuthRepository
// دلوقتي بنعمل UI flow صح وجاهز للربط
 
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
 
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}
 
class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
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
 
    // TODO: لما الباك يضيف endpoint الـ forgot password
    // هتبقى كده:
    //
    // final result = await _authRepository.forgotPassword(
    //   email: _emailController.text.trim(),
    // );
    //
    // if (result.success) {
    //   setState(() { _isLoading = false; _emailSent = true; });
    // } else {
    //   setState(() => _isLoading = false);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(result.message!), backgroundColor: Colors.red),
    //   );
    // }
 
    // مؤقتاً: نعمل simulate للـ UI
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _emailSent = true;
    });
  }
 
  Future<void> _handleResendEmail() async {
    setState(() => _isLoading = true);
 
    // TODO: نفس الـ endpoint هيتبعت تاني
    await Future.delayed(const Duration(seconds: 2));
 
    if (!mounted) return;
    setState(() => _isLoading = false);
 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reset link has been resent to your email'),
        backgroundColor: Colors.green,
      ),
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
                  onBackToLogin: () => Navigator.pop(context),
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