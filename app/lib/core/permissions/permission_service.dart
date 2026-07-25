import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestBluetoothPermissions() async {
    final scan = await Permission.bluetoothScan.request();
    final connect = await Permission.bluetoothConnect.request();
    final location = await Permission.locationWhenInUse.request();

    return scan.isGranted &&
        connect.isGranted &&
        location.isGranted;
  }
}
