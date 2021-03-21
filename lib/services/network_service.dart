import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:simplechat/services/load_service.dart';
import 'package:simplechat/utils/constants.dart';

class NetworkService {
  final BuildContext context;

  NetworkService(this.context);

  Future<dynamic> ajax(String link, Map<String, dynamic> parameter, {bool isProgress = false, bool isFullUrl = false}) async {
    if (isProgress && context != null) LoadService().showLoading(context);

    var url = Uri.https(DOMAIN, isFullUrl? link : '/Backend/' + link, {'q': '{https}'});

    print('===== response link ===== \n${url.toString()}');
    print('===== response params ===== \n${parameter.toString()}');

    final response = await http.post(url,
      body: parameter,
    ).timeout(Duration(minutes: 1));
    if (isProgress && context != null) LoadService().hideLoading(context);
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('===== $link response ===== \n${response.body}');
      return jsonDecode(response.body);
    } else {
      print(link + ' failed ===> ${response.statusCode}');
      Exception(response.statusCode);
    }
  }

}