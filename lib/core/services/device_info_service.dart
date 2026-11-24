import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  DeviceInfoService._internal();

  static final DeviceInfoService instance = DeviceInfoService._internal();

  factory DeviceInfoService() => instance;

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static String get deviceType {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return Platform.operatingSystem.toLowerCase();
  }

  static Future<String> getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        return androidInfo.model.isNotEmpty ? androidInfo.model : 'Android Device';
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.utsname.machine.isNotEmpty ? iosInfo.utsname.machine : (iosInfo.name.isNotEmpty ? iosInfo.name : 'iOS Device');
      }
    } catch (_) {}
    return 'Unknown Device';
  }
}
