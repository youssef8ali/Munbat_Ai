// lib/core/utils/permissions_handler.dart

import 'package:permission_handler/permission_handler.dart';

class PermissionsHandler {
  // ─── Camera ───────────────────────────────────────────────────────────────

  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> hasCameraPermission() async {
    return (await Permission.camera.status).isGranted;
  }

  // ─── Gallery ──────────────────────────────────────────────────────────────

  /// بنطلب الاتنين مع بعض — الجهاز هيستخدم اللي يناسبه تلقائياً
  static Future<bool> requestGalleryPermission() async {
    // نطلب photos (Android 13+) وstorage (Android 12-) مع بعض
    final statuses = await [
      Permission.photos,
      Permission.storage,
    ].request();

    final photos = statuses[Permission.photos];
    final storage = statuses[Permission.storage];

    // لو أي منهم granted يبقى تمام
    if (photos?.isGranted == true || storage?.isGranted == true) {
      return true;
    }

    // لو permanently denied نفتح الـ settings
    if (photos?.isPermanentlyDenied == true ||
        storage?.isPermanentlyDenied == true) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  static Future<bool> hasGalleryPermission() async {
    final photos = await Permission.photos.status;
    final storage = await Permission.storage.status;
    return photos.isGranted || storage.isGranted;
  }

  // ─── Open Settings ────────────────────────────────────────────────────────

  static Future<void> openCameraSettings() async {
    await openAppSettings();
  }
}