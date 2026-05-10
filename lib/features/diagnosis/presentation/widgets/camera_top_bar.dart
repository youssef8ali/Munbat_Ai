
// Top Bar with close and info buttons
import 'package:flutter/material.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/circle_button.dart';

class CameraTopBar extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onShowInfo;

  const CameraTopBar({
    super.key,
    required this.onClose,
    required this.onShowInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 40,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleButton(
            icon: Icons.close,
            onPressed: onClose,
          ),
          Row(
            children: [
              CircleButton(
                icon: Icons.help_outline,
                onPressed: onShowInfo,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
