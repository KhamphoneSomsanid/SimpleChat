import 'dart:async';
import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simplechat/main.dart';
import 'package:simplechat/models/user_model.dart';
import 'package:simplechat/screens/setting/qr_scan_screen.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/button_widget.dart';
import 'package:simplechat/widgets/empty_widget.dart';
import 'package:simplechat/widgets/image_widget.dart';
import 'package:simplechat/widgets/textfield_widget.dart';
// import 'package:qrscan/qrscan.dart' as scanner;

class InviteScreen extends StatefulWidget {
  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var inviteFriends = [];
  var showUsers = [];
  var searchController = TextEditingController();

  Iterable<Contact> contacts;

  @override
  void initState() {
    super.initState();

    _getContacts();
    Timer.run(() {
      _getInvite();
    });

    searchController.addListener(() {
      filterContacts();
    });
  }

  void filterContacts() {
    String search = searchController.text;
    showUsers.clear();
    if (search.length > 7) {
      print('search ===> $search');
      for (var user in inviteFriends) {
        if (user.email.toLowerCase().contains(search.toLowerCase())) {
          showUsers.add(user);
        }
      }
    }
    setState(() {});
  }

  Future<void> _getContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus != PermissionStatus.granted) {
      return;
    }
    contacts = await ContactsService.getContacts(withThumbnails: false);
    print('contacts ===> ${contacts.length}');
    _getShowContacts();
  }

  Future<PermissionStatus> _getContactPermission() async {
    var permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      await [Permission.contacts].request();
      permission = await Permission.contacts.status;
    }
    return permission;
  }

  void _getShowContacts() {
    showUsers.clear();
    for (var user in inviteFriends) {
      bool isContain = false;
      for (var contact in contacts) {
        for (var email in contact.emails) {
          if (email.value.toLowerCase() == user.email.toLowerCase()) {
            isContain = true;
            break;
          }
        }
        if (isContain) {
          break;
        }
      }
      if (isContain) {
        showUsers.add(user);
      }
    }
    setState(() {});
  }

  void _getInvite() async {
    var param = {
      'id': currentUser.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_invite', param, isProgress: true);
    if (resp['ret'] == 10000) {
      inviteFriends.clear();
      inviteFriends =
          (resp['result'].map((item) => UserModel.fromMap(item)).toList());
      print('inviteFriends ===> ${inviteFriends.length}');
      _getShowContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: MainBarWidget(
          titleString: 'Invite Friend',
          titleIcon: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios)),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog();
                },
                icon: Icon(Icons.help_outline)),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(offsetBase),
          child: Column(
            children: [
              SearchWidget(
                searchController: searchController,
                onClear: () {
                  setState(() {
                    searchController.text = '';
                  });
                },
                onChanged: (value) {},
              ),
              SizedBox(
                height: offsetSm,
              ),
              Expanded(
                child: showUsers.isEmpty
                    ? EmptyWidget(
                        title:
                            'The request friends is not existed. After some delay, please try it again.',
                      )
                    : ListView.builder(
                        itemCount: showUsers.length,
                        itemBuilder: (context, i) {
                          return showUsers[i].itemRequestWidget(() {
                            _request(showUsers[i]);
                          });
                        }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            NavigatorService(context).pushToWidget(
                screen: QrScanScreen(),
                pop: (value) {
                  if (value != null) {
                    var userData = StringService.decryptString(value);
                    var invitedUser = UserModel.fromMap(jsonDecode(userData));
                    print('invitedUser ===> ${invitedUser.toJson()}');

                    DialogService(context).showCustomDialog(
                        titleWidget: Text('Invite Friend',style: boldText.copyWith(fontSize: fontLg),),
                        bodyWidget: Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: EdgeInsets.all(offsetBase),
                          child: Center(
                            child: Column(
                              children: [
                                CircleAvatarWidget(headurl: invitedUser.imgurl),
                                SizedBox(height: offsetBase,),
                                Text('Full Name: ${invitedUser.username}', style: semiBold.copyWith(fontSize: fontMd),),
                                SizedBox(height: offsetXSm,),
                                Text(invitedUser.email, style: mediumText.copyWith(fontSize: fontBase),),
                              ],
                            ),
                          ),
                        ),
                        bottomWidget: Container(
                          padding: EdgeInsets.all(offsetBase),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(offsetBase),
                                bottomRight: Radius.circular(offsetBase)),
                          ),
                          child: Row(
                            children: [
                              Spacer(),
                              Container(
                                width: 100, height: 40,
                                child: FullWidthButton(
                                  title: 'Cancel',
                                  color: Colors.red,
                                  action: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: offsetMd,
                              ),
                              Container(
                                width: 100, height: 40,
                                child: FullWidthButton(
                                  title: 'Send',
                                  action: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                    _request(invitedUser);
                                  },
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ));
                  }
                }
            );
          },
          child: Icon(Icons.qr_code_scanner),
        ),
      ),
    );
  }

  void _request(dynamic user) async {
    var resp = await user.request(context);
    if (resp['ret'] == 10000) {
      DialogService(context).showSnackbar(resp['msg'], _scaffoldKey);
      socketService.sendRequest(user.id);
      setState(() {
        searchController.text = '';
        _getInvite();
      });
    } else {
      DialogService(context)
          .showSnackbar(resp['msg'], _scaffoldKey, type: SnackBarType.WARING);
    }
  }

  void showDialog() {
    DialogService(context).showCustomModalBottomSheet(
      titleWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: offsetBase),
        child: Text(
          'How to send a friend invitation?',
          style: boldText.copyWith(fontSize: fontLg),
        ),
      ),
      bodyWidget: Container(
        padding: EdgeInsets.all(offsetBase),
        child: Column(
          children: [
            Text(
              'You can search a friend email in here.' +
                  '\nThat email should be matched over 8 characters.' +
                  '\nAfter input, you can see a list to match friends, then you can click the invite send button.',
              style: semiBold.copyWith(fontSize: fontMd),
            ),
            SizedBox(
              height: offsetSm,
            ),
            Text(
              'Or you can share your qr code in profile screen.\nPlease reference qr code generator and using.',
              style: semiBold.copyWith(fontSize: fontMd),
            ),
          ],
        ),
      ),
    );
  }
}
