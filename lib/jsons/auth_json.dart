import 'package:flutter/material.dart';

enum SocialType {
  APPLE,
  GOOGLE,
  WECHAT
}

var socialLoginJson = [
  {
    'icon' : 'assets/icons/ic_login_apple.svg',
    'color' : Colors.black,
    'size' : 54.0,
    'type' : SocialType.APPLE,
    'isShown' : true,
  },
  {
    'icon' : 'assets/icons/ic_login_google.svg',
    'color' : Colors.red,
    'size' : 54.0,
    'type' : SocialType.GOOGLE,
    'isShown' : true,
  },
  {
    'icon' : 'assets/icons/ic_login_wechat.svg',
    'color' : Colors.green,
    'size' : 54.0,
    'type' : SocialType.WECHAT,
    'isShown' : false,
  },
];