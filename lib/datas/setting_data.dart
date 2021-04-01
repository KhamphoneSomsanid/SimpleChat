import 'package:flutter/material.dart';
import 'package:simplechat/screens/post/follow_post_screen.dart';
import 'package:simplechat/screens/setting/chat_setting_screen.dart';
import 'package:simplechat/screens/setting/my_post_screen.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/constants.dart';

var settingMenuData = [
  {
    'title': 'Post Management',
    'color': blueColor,
    'visible': true,
    'buttons': [
      {
        'icon': 'assets/icons/ic_post.svg',
        'title': 'My Post(s)',
        'actionWidget': MyPostScreen(),
      },
      {
        'icon': 'assets/icons/ic_link.svg',
        'title': 'Follow Post(s)',
        'actionWidget': FollowPostScreen(),
      },
    ],
  },
  {
    'title': 'Chat Management',
    'color': Colors.deepPurpleAccent,
    'visible': true,
    'buttons': [
      {
        'icon': 'assets/icons/ic_chat.svg',
        'title': 'Chat',
        'actionWidget': ChatSettingScreen(),
      },
      {
        'icon': 'assets/icons/ic_friend.svg',
        'title': 'Friend(s)',
        'actionWidget': null,
      },
    ],
  },
  {
    'title': 'Nearby Management',
    'color': Colors.red,
    'visible': appSettingInfo['isNearby'],
    'buttons': [
      {
        'icon': 'assets/icons/ic_post.svg',
        'title': 'Nearby',
        'actionWidget': null,
      },
    ],
  },
  {
    'title': 'App Management',
    'color': Colors.orange,
    'visible': true,
    'buttons': [
      {
        'icon': 'assets/icons/ic_notification_on.svg',
        'title': 'Notification',
        'actionWidget': null,
      },
      {
        'icon': 'assets/icons/ic_rating.svg',
        'title': 'App Rating',
        'actionWidget': null,
      },
      {
        'icon': 'assets/icons/ic_support.svg',
        'title': 'Support Team',
        'actionWidget': null,
      },
    ],
  },
];
