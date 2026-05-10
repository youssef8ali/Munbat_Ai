
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/utils/app_extensions.dart';

/// Modern Welcome Logo with animated gradient overlay
class ModernWelcomeLogo extends StatelessWidget {
  const ModernWelcomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow effect
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.white.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Logo container
            Container(
              width: context.width / 2,
              height: context.height * 0.2,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                    spreadRadius: -5,
                  ),
                  BoxShadow(
                    color: AppColors.white.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Lottie.asset(
                  "assets/animations/welcome_animation.json",
                  repeat: false,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        // App name with modern styling
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [AppColors.white, AppColors.white.withOpacity(0.95)],
          ).createShader(bounds),
          child: const Text(
            'Munbat AI',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.eco_outlined, color: AppColors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                'AI for a Greener Future',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
