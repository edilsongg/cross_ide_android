import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<bool> requestCamera() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
      // We didn't ask for permission yet.
    } else if (status.isPermanentlyDenied) {
      await Permission.camera.request();
      // We didn't ask for permission yet.
    }
    status = await Permission.camera.status;
    return status.isGranted;
  }

  static Future<bool> requestStorage() async {
    var status = await Permission.manageExternalStorage.status;
    // Log.d(status);
    if (status.isDenied) {
      await Permission.manageExternalStorage.request();
      // We didn't ask for permission yet.
    } else if (status.isPermanentlyDenied) {
      await Permission.manageExternalStorage.request();
      // We didn't ask for permission yet.
    }
    status = await Permission.manageExternalStorage.status;
    return status.isGranted;
  }
}
