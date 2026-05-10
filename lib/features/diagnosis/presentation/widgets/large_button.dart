// Large center button
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';

class LargeButton extends StatelessWidget {
  final double size;
  final VoidCallback onPressed;

  const LargeButton({
    Key? key,
    required this.size,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.textWhite,
            width: 4,
          ),
        ),
      ),
    );
  }
}
