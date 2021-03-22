import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

class StringService {
  static String getCurrentTime(String str) {
    if (str.isNotEmpty) {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime dateTime = dateFormat.parse(str, true);
      DateTime localTime = dateTime.toLocal();
      return dateFormat.format(localTime);
    } else
      return '';
  }

  static String getCurrentTimeValue(String str) {
    if (str.isNotEmpty) {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime dateTime = dateFormat.parse(str, true);
      DateTime localTime = dateTime.toLocal();

      final date2 = DateTime.now();
      final diffDay = date2.difference(localTime).inDays;
      if (diffDay > 7) return dateFormat.format(localTime).split(' ')[0];
      if (diffDay > 1) return DateFormat("EEEE").format(localTime);
      if (diffDay > 0) return 'Yesterday';

      final diffHour = date2.difference(dateTime).inHours;
      if (diffHour > 0) return '${diffHour}hr ago';

      final diffMin = date2.difference(dateTime).inMinutes;
      if (diffMin > 0) return '${diffMin}m ago';

      return 'less a min';
    } else
      return '';
  }

  static String getChatTime(String str) {
    if (str.isNotEmpty) {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime dateTime = dateFormat.parse(str, true);
      DateTime localTime = dateTime.toLocal();

      return DateFormat("h:mm a").format(localTime);
    } else
      return '';
  }

  static String formatName(String str) {
    if (str != null && str.isNotEmpty)
      return str[0].toUpperCase() + str.substring(1);
    else if (str.isEmpty)
      return '';
    else
      return null;
  }

  static String getCurrentUTCTime() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc());
  }

  static String getBase64FromFile(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    return base64Encode(imageBytes);
  }
}
