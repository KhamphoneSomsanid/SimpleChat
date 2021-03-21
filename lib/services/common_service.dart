import 'dart:io';
import 'dart:math';

import 'package:device_info/device_info.dart';

Future<String> getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  } else {
    Random r = new Random();
    int i1 = r.nextInt(99999 - 10000) + 10000;
    return 'Random_${DateTime.now()}_$i1';
  }
}
