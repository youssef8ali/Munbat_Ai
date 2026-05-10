import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color backgroundColor;

  const CircleButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 48,
    this.backgroundColor = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.textWhite,
          size: size * 0.5,
        ),
      ),
    );
  }
}
