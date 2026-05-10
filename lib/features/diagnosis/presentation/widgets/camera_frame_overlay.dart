
// Frame overlay
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';

class CameraFrameOverlay extends StatelessWidget {
  const CameraFrameOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
