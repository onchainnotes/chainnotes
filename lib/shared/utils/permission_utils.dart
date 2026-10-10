import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {

  static Future<bool> getIsPhotoPermission({bool isOnlyAdd = false}) async {
    PermissionStatus status;
    if (Platform.isIOS) {
      if (isOnlyAdd) {
        status = await Permission.photosAddOnly.request();
      } else {
        status = await Permission.photos.request();
      }
    } else if (Platform.isAndroid) {
      return true;
    } else {
      status = PermissionStatus.denied;
    }

    if (status.isGranted || status.isLimited) {
      return true;
    } else {
      _showPhotoNoPermissionView(status);
      return false;
    }
  }

  static Future<bool> getIsCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      return true;
    } else {
      _showCameraNoPermissionView(status);
      return false;
    }
  }

  static void _showPhotoNoPermissionView(PermissionStatus status) {

    if (status.isPermanentlyDenied || status.isRestricted) {
      openAppSettings();
    }
  }

  static void _showCameraNoPermissionView(PermissionStatus status) {
    if (status.isPermanentlyDenied || status.isRestricted) {
      openAppSettings();
    }
  }
}
