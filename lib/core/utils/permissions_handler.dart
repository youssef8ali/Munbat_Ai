// lib/utils/permissions_handler.dart
import 'package:permission_handler/permission_handler.dart';

class PermissionsHandler {
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> requestGalleryPermission() async {
    final status = await Permission.photos.request();
    if (status.isDenied) {
      return false;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return status.isGranted;
  }

  static Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  static Future<bool> hasGalleryPermission() async {
    final status = await Permission.photos.status;
    return status.isGranted;
  }

  static Future<void> openCameraSettings() async {
    openAppSettings();
  }
}