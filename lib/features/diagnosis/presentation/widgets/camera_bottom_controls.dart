// lib/features/diagnosis/presentation/widgets/camera_bottom_controls.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/constants/app_constants.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/circle_button.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/large_button.dart';

class CameraBottomControls extends StatelessWidget {
  final VoidCallback onTakePicture;
  final VoidCallback onPickFromGallery;
  final VoidCallback onSwitchCamera; // ✅ جديد
  final bool hasFrontCamera;         // ✅ نخفي الزرار لو مفيش كاميرا أمامية

  const CameraBottomControls({
    super.key,
    required this.onTakePicture,
    required this.onPickFromGallery,
    required this.onSwitchCamera,
    this.hasFrontCamera = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // ✅ زرار الجاليري
          CircleButton(
            icon: Icons.image,
            size: 50,
            onPressed: onPickFromGallery,
            backgroundColor: Colors.black45,
          ),

          // زرار التقاط الصورة
          LargeButton(
            size: 80,
            onPressed: onTakePicture,
          ),

          // ✅ زرار تبديل الكاميرا — بيختفي لو مفيش كاميرا أمامية
          hasFrontCamera
              ? CircleButton(
                  icon: Icons.cameraswitch,
                  size: 50,
                  onPressed: onSwitchCamera,
                  backgroundColor: Colors.black45,
                )
              : const SizedBox(width: 50), // placeholder للمحاذاة
        ],
      ),
    );
  }
}