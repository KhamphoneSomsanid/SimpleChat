import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simplechat/main.dart';
import 'package:simplechat/models/room_model.dart';
import 'package:simplechat/screens/chat/voice_request_screen.dart';
import 'package:simplechat/screens/main/chat_list_screen.dart';
import 'package:simplechat/screens/main/nearby_screen.dart';
import 'package:simplechat/screens/main/noti_screen.dart';
import 'package:simplechat/screens/main/post_screen.dart';
import 'package:simplechat/screens/main/setting_screen.dart';
import 'package:simplechat/screens/post/add_post_screen.dart';
import 'package:simplechat/screens/setting/invite_screen.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/notification_service.dart';
import 'package:simplechat/services/pref_service.dart';
import 'package:simplechat/services/socket_service.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<RoomModel> rooms = [];

  @override
  void initState() {
    super.initState();

    NotificationService(context).init();

    socketService = injector.get<SocketService>();
    socketService.createSocketConnection(
      request: request,
    );

    initInAppPurchase();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print("-----\napp in resumed-------");
        _enterApp();
        break;
      case AppLifecycleState.inactive:
        print("-----\napp in inactive-----");
        _leaveApp();
        break;
      case AppLifecycleState.paused:
        print("-----\napp in paused-----");
        await PreferenceService().setCurrentUser();
        break;
      case AppLifecycleState.detached:
        print("-----\napp in detached-----");
        break;
    }
  }

  void _leaveApp() async {
    await PreferenceService().setCurrentUser();
    var param = {
      'id': currentUser.id,
    };
    await NetworkService(context)
        .ajax('chat_leave_app', param, isProgress: false);
  }

  void _enterApp() async {
    if (currentUser == null)
      currentUser = await PreferenceService().getCurrentUser();
    var param = {
      'id': currentUser.id,
    };
    await NetworkService(context)
        .ajax('chat_enter_app', param, isProgress: false);
  }

  void request(dynamic value) {
    NavigatorService(context).pushToWidget(
        screen: VoiceRequestScreen(data: value),
        pop: (val) {
          setState(() {});
        });
  }

  initInAppPurchase() async {
    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: $result');
  }

  var _screens = <int, Widget Function()>{
    0: () => PostScreen(),
    1: () => ChatListScreen(),
    3: () => appSettingInfo['isNearby'] ? NearByScreen() : NotiScreen(),
    4: () => SettingScreen(),
  };

  var bottomItems = [
    {
      'icon': 'assets/icons/ic_post.svg',
      'title': 'Posts',
    },
    {
      'icon': 'assets/icons/ic_chat.svg',
      'title': 'Chats',
    },
    {
      'icon': '',
      'title': '',
    },
    appSettingInfo['isNearby']
        ? {
            'icon': 'assets/icons/ic_nearby.svg',
            'title': 'Nearby',
          }
        : {
            'icon': 'assets/icons/ic_notification_on.svg',
            'title': 'Notify',
          },
    {
      'icon': 'assets/icons/ic_setting.svg',
      'title': 'Setting',
    },
  ];
  var selectedIndex = 0;

  Color getColor(int index) {
    if (index == selectedIndex) {
      return Colors.green;
    } else {
      return Colors.green.withOpacity(0.6);
    }
  }

  Icon getIcon() {
    switch (selectedIndex) {
      case 0:
      case 1:
        return Icon(Icons.add);
      case 3:
        return appSettingInfo['isNearby']
            ? Icon(Icons.add)
            : Icon(Icons.admin_panel_settings_outlined);
      case 4:
        return Icon(Icons.admin_panel_settings_outlined);
    }
    return Icon(Icons.add);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        body: _screens[selectedIndex](),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: SizedBox(
            height: 54,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                for (var item in bottomItems)
                  item['icon'].isEmpty
                      ? Expanded(
                          child: Container(),
                          flex: 3,
                        )
                      : Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = bottomItems.indexOf(item);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(offsetSm),
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    item['icon'],
                                    width: 18.0,
                                    height: 18.0,
                                    fit: BoxFit.fitHeight,
                                    color: getColor(bottomItems.indexOf(item)),
                                  ),
                                  SizedBox(
                                    height: offsetXSm,
                                  ),
                                  Text(
                                    item['title'],
                                    style: semiBold.copyWith(
                                        fontSize: fontSm,
                                        color: getColor(
                                            bottomItems.indexOf(item))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
              ],
            ),
          ),
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
        ),
        floatingActionButton: FloatingActionButton(
            child: getIcon(),
            onPressed: () {
              switch (selectedIndex) {
                case 0:
                  NavigatorService(context).pushToWidget(
                      screen: AddPostScreen(),
                      pop: (value) {
                        if (value != null) {
                          setState(() {});
                        }
                      });
                  break;
                case 1:
                  NavigatorService(context).pushToWidget(
                      screen: InviteScreen(),
                      pop: (value) {
                        if (value != null) {
                          setState(() {});
                        }
                      });
                  break;
              }
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
