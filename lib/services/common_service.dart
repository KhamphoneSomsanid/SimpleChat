import 'dart:io';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

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

bool checkVersion(String appVersion, PackageInfo packageInfo) {
  var currentVersions = packageInfo.version.split('.');
  var difVersions = appVersion.split('.');

  var cValue = 0;
  var dValue = 0;

  for (var index = 0; index < currentVersions.length; index++) {
    var current = int.tryParse(currentVersions[index]);
    cValue = cValue * 10 + current;

    var dif = int.tryParse(difVersions[index]);
    dValue = dValue * 10 + dif;
  }
  print('cValue dValue ===> $cValue $dValue');
  return !(dValue > cValue);
}
