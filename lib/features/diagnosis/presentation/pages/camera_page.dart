import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/utils/permissions_handler.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/camera_Initializing_view.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/camera_preview_view.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/permission_denied_view.dart';
import 'diagnosis_result_screen.dart';


class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraPage> {
  late CameraController _cameraController;
  late ImagePicker _imagePicker;
  bool isPhotoMode = true;
  bool _isCameraInitialized = false;
  bool _cameraPermissionDenied = false;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final hasCameraPermission =
          await PermissionsHandler.requestCameraPermission();

      if (!hasCameraPermission) {
        setState(() {
          _cameraPermissionDenied = true;
        });
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[0],
          ResolutionPreset.high,
        );

        await _cameraController.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
            _cameraPermissionDenied = false;
          });
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
      if (mounted) {
        setState(() {
          _cameraPermissionDenied = true;
        });
      }
    }
  }

  Future<void> _takePicture() async {
    try {
      if (!_cameraController.value.isInitialized) return;

      final image = await _cameraController.takePicture();

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiagnosisResultScreen(
              imagePath: image.path,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error taking picture: $e');
      if (mounted) {
        _showErrorSnackBar('Failed to capture photo');
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final hasGalleryPermission =
          await PermissionsHandler.requestGalleryPermission();

      if (!hasGalleryPermission) {
        if (mounted) {
          _showPermissionDeniedDialog(
            'Gallery Access Denied',
            'Please enable gallery access in settings to pick images.',
            () => PermissionsHandler.openCameraSettings(),
          );
        }
        return;
      }

      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiagnosisResultScreen(
              imagePath: image.path,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        _showErrorSnackBar('Failed to pick image');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.categoryDisease,
      ),
    );
  }

  void _showPermissionDeniedDialog(
    String title,
    String message,
    VoidCallback onSettingsTap,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onSettingsTap();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraPermissionDenied) {
      return PermissionDeniedView(
        onOpenSettings: () {
          PermissionsHandler.openCameraSettings();
        },
        onUseGallery: _pickImageFromGallery,
      );
    }

    if (!_isCameraInitialized) {
      return const CameraInitializingView();
    }

    return CameraPreviewView(
      cameraController: _cameraController,
      isPhotoMode: isPhotoMode,
      onPhotoModeChanged: (value) {
        setState(() => isPhotoMode = value);
      },
      onTakePicture: _takePicture,
      onPickFromGallery: _pickImageFromGallery,
      onClose: () => Navigator.pop(context),
    );
  }
}