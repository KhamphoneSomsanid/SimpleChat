import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simplechat/main.dart';
import 'package:simplechat/models/user_model.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/empty_widget.dart';
import 'package:simplechat/widgets/textfield_widget.dart';

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
    setState(() { });
  }

  void _getInvite() async {
    var param = {
      'id' : currentUser.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_invite', param, isProgress: true);
    if (resp['ret'] == 10000) {
      inviteFriends.clear();
      inviteFriends = (resp['result'].map((item) => UserModel.fromMap(item)).toList());
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
        appBar: MainBarWidget(
          titleString: 'Invite Friend',
          titleIcon: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios)),
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
                  title: 'The request friends is not existed. After some delay, please try it again.',
                ) : ListView.builder(
                    itemCount: showUsers.length,
                    itemBuilder: (context, i) {
                      return showUsers[i].itemRequestWidget(
                          () {
                            _request(showUsers[i]);
                          }
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _request(dynamic user) async {
    var param = {
      'id' : currentUser.id,
      'userid' : user.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_send_request', param, isProgress: true);
    if (resp['ret'] == 10000) {
      DialogService(context).showSnackbar(resp['msg'], _scaffoldKey);
      socketService.sendRequest(user.id);
      setState(() {
        searchController.text = '';
        _getInvite();
      });
    } else {
      DialogService(context).showSnackbar(resp['msg'], _scaffoldKey, type: SnackBarType.WARING);
    }
  }
}
