
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';

/// Modern Welcome Text with better typography
class ModernWelcomeText extends StatelessWidget {
  const ModernWelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Welcome to the Future',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            'Join us in making the world more sustainable with the power of artificial intelligence',
            style: TextStyle(
              color: AppColors.white.withOpacity(0.9),
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.6,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
