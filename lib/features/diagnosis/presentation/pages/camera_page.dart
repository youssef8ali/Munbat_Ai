// lib/features/diagnosis/presentation/pages/camera_page.dart

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

  List<CameraDescription> _cameras = []; // ✅ قائمة الكاميرات المتاحة
  int _currentCameraIndex = 0;           // ✅ index الكاميرا الحالية

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _initializeCamera();
  }

  Future<void> _initializeCamera({int cameraIndex = 0}) async {
    try {
      final hasCameraPermission =
          await PermissionsHandler.requestCameraPermission();

      if (!hasCameraPermission) {
        setState(() => _cameraPermissionDenied = true);
        return;
      }

      // ✅ جيب كل الكاميرات وحفظها
      _cameras = await availableCameras();

      if (_cameras.isNotEmpty) {
        // ✅ لو كان فيه controller قديم، نغلقه الأول
        if (_isCameraInitialized) {
          await _cameraController.dispose();
        }

        _cameraController = CameraController(
          _cameras[cameraIndex],
          ResolutionPreset.high,
        );

        await _cameraController.initialize();

        if (mounted) {
          setState(() {
            _currentCameraIndex = cameraIndex;
            _isCameraInitialized = true;
            _cameraPermissionDenied = false;
          });
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error initializing camera: $e');
      if (mounted) {
        setState(() => _cameraPermissionDenied = true);
      }
    }
  }

  // ✅ تبديل بين الكاميرا الأمامية والخلفية
  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return; // مفيش كاميرا تانية

    final nextIndex = (_currentCameraIndex + 1) % _cameras.length;
    setState(() => _isCameraInitialized = false); // نعرض loading
    await _initializeCamera(cameraIndex: nextIndex);
  }

  Future<void> _takePicture() async {
    try {
      if (!_cameraController.value.isInitialized) return;

      final image = await _cameraController.takePicture();

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DiagnosisResultScreen(imagePath: image.path),
          ),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error taking picture: $e');
      if (mounted) _showErrorSnackBar('Failed to capture photo');
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

      final image = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DiagnosisResultScreen(imagePath: image.path),
          ),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error picking image: $e');
      if (mounted) _showErrorSnackBar('Failed to pick image');
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
    if (_isCameraInitialized) _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraPermissionDenied) {
      return PermissionDeniedView(
        onOpenSettings: () => PermissionsHandler.openCameraSettings(),
        onUseGallery: _pickImageFromGallery,
      );
    }

    if (!_isCameraInitialized) {
      return const CameraInitializingView();
    }

    return CameraPreviewView(
      cameraController: _cameraController,
      isPhotoMode: isPhotoMode,
      onPhotoModeChanged: (value) => setState(() => isPhotoMode = value),
      onTakePicture: _takePicture,
      onPickFromGallery: _pickImageFromGallery,
      onSwitchCamera: _switchCamera,           // ✅ جديد
      hasFrontCamera: _cameras.length > 1,     // ✅ نخفي الزرار لو مفيش كاميرا أمامية
      onClose: () => Navigator.pop(context),
    );
  }
}