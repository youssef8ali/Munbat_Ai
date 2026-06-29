// lib/features/auth/presentation/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:munbat_ai/features/auth/presentation/pages/email_verification_page.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/header_section.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/login_form_card.dart';
import 'package:munbat_ai/features/home/presentation/pages/main_navigation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _keepMeSignedIn = false;
  bool _isLoading = false;

  final _authRepository = AuthRepository();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await _authRepository.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('keep_signed_in', _keepMeSignedIn);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationPage()),
        (route) => false,
      );
    } else {
      final msg = result.message ?? '';

      // ✅ لو الـ API رجّع رسالة إن الـ email مش verified، روح لصفحة الـ Verification
      if (msg.toLowerCase().contains('verify')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EmailVerificationPage(
              email: _emailController.text.trim(),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg.isNotEmpty ? msg : 'An error occurred, please try again'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderSection(),
            Transform.translate(
              offset: const Offset(0, -40),
              child: LoginFormCard(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                isPasswordVisible: _isPasswordVisible,
                keepMeSignedIn: _keepMeSignedIn,
                isLoading: _isLoading,
                onPasswordVisibilityToggle: () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                },
                onKeepMeSignedInChanged: (value) {
                  setState(() => _keepMeSignedIn = value);
                },
                onLogin: _handleLogin,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}