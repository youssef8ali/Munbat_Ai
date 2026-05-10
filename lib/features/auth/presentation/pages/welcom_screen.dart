import 'package:flutter/material.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/modern_welcome_buttons.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/modern_welcome_logo.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/modern_welcome_text.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.primary.withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const ModernWelcomeLogo(),
                const SizedBox(height: 48),
                const ModernWelcomeText(),
                const Spacer(flex: 3),
                const ModernWelcomeButtons(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
