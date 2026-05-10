// App Logo Widget
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(image: 
            AssetImage("assets/images/main_images/logo.png")
            )
          ),
         
        ),
        const SizedBox(height: 12),
        const Text(
          'Munbat AI',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'AI for a Greener Future',
          style: TextStyle(
            color: AppColors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
