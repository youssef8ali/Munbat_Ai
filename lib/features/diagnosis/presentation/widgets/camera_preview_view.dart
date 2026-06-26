// lib/features/diagnosis/presentation/widgets/camera_preview_view.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/constants/app_constants.dart';
import 'package:munbat_ai/core/widgets/app_dialogs.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/camera_Instruction_text.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/camera_bottom_controls.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/camera_frame_overlay.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/camera_top_bar.dart';

class CameraPreviewView extends StatelessWidget {
  final CameraController cameraController;
  final bool isPhotoMode;
  final Function(bool) onPhotoModeChanged;
  final VoidCallback onTakePicture;
  final VoidCallback onPickFromGallery;
  final VoidCallback onSwitchCamera; // ✅ جديد
  final bool hasFrontCamera;         // ✅ جديد
  final VoidCallback onClose;

  const CameraPreviewView({
    super.key,
    required this.cameraController,
    required this.isPhotoMode,
    required this.onPhotoModeChanged,
    required this.onTakePicture,
    required this.onPickFromGallery,
    required this.onSwitchCamera,
    required this.onClose,
    this.hasFrontCamera = true,
  });

  static void _showInfoDialog(BuildContext context) {
    showInfoDialog(
      context: context,
      title: 'Diagnosis Tips',
      message: 'For best results:\n\n'
          '• Use good lighting\n'
          '• Center the leaf in the frame\n'
          '• Avoid shadows\n'
          '• Keep the leaf steady',
      buttonText: 'Got It!',
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera preview
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CameraPreview(cameraController),
          ),
          // Dark overlay
          Container(color: Colors.black26),
          // Content
          Column(
            children: [
              CameraTopBar(
                onClose: onClose,
                onShowInfo: () => _showInfoDialog(context),
              ),
              const Spacer(),
              CameraFrameOverlay(),
              const Spacer(),
              CameraInstructionText(),
              SizedBox(height: AppConstants.paddingLarge),
              // ✅ بنمرر onSwitchCamera و hasFrontCamera
              CameraBottomControls(
                onTakePicture: onTakePicture,
                onPickFromGallery: onPickFromGallery,
                onSwitchCamera: onSwitchCamera,
                hasFrontCamera: hasFrontCamera,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


