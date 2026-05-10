// Bottom controls
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/constants/app_constants.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/circle_button.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/large_button.dart';


class CameraBottomControls extends StatelessWidget {
  final VoidCallback onTakePicture;
  final VoidCallback onPickFromGallery;

  const CameraBottomControls({
    super.key,
    required this.onTakePicture,
    required this.onPickFromGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppConstants.paddingLarge,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleButton(
            icon: Icons.image,
            size: 50,
            onPressed: onPickFromGallery,
            backgroundColor: Colors.black45,
          ),
          LargeButton(
            size: 80,
            onPressed: onTakePicture,
          ),
          CircleButton(
            icon: Icons.cameraswitch,
            size: 50,
            onPressed: () {},
            backgroundColor: Colors.black45,
          ),
        ],
      ),
    );
  }
}
