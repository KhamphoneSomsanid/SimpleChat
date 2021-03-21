import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simplechat/main.dart';
import 'package:simplechat/models/user_model.dart';
import 'package:simplechat/screens/setting/user_screen.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/empty_widget.dart';
import 'package:simplechat/widgets/textfield_widget.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var requestFriends = [];
  var showUsers = [];
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _getRequest();
    });

    searchController.addListener(() {
      filterData();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _getRequest() async {
    var param = {
      'id' : currentUser.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_request', param, isProgress: true);
    if (resp['ret'] == 10000) {
      requestFriends.clear();
      requestFriends = (resp['result'].map((item) => UserModel.fromMap(item)).toList());
      filterData();
    }
  }

  void filterData() {
    String search = searchController.text;
    showUsers.clear();
    for (var user in requestFriends) {
      if (user.isContainKey(search)) {
        showUsers.add(user);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MainBarWidget(
          titleString: 'Request Friend',
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
                  title: 'The requested friends is not existed. After some delay, please try it again.',
                ) : ListView.builder(
                    itemCount: showUsers.length,
                    itemBuilder: (context, i) {
                      return showUsers[i].itemAcceptWidget(
                          () {
                            _accept(showUsers[i]);
                          }, () {
                            _cancel(showUsers[i]);
                          }, () {
                            _detail(showUsers[i]);
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

  void _accept(dynamic user) async {
    var param = {
      'id' : currentUser.id,
      'userid' : user.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_submit_accept', param, isProgress: true);
    if (resp['ret'] == 10000) {
      DialogService(context).showSnackbar(resp['msg'], _scaffoldKey);

      String roomID = '${resp['result']}';
      socketService.acceptRequest(user.id, roomID);

      searchController.text = '';
      _getRequest();
    } else {
      DialogService(context).showSnackbar(resp['msg'], _scaffoldKey, type: SnackBarType.WARING);
    }
  }

  void _cancel(dynamic user) async {
    var param = {
      'id' : currentUser.id,
      'userid' : user.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_submit_cancel', param, isProgress: true);
    if (resp['ret'] == 10000) {
      DialogService(context).showSnackbar(resp['msg'], _scaffoldKey);
      searchController.text = '';
      _getRequest();
    } else {
      DialogService(context).showSnackbar(resp['msg'], _scaffoldKey, type: SnackBarType.WARING);
    }
  }

  void _detail(dynamic user) {
    NavigatorService(context).pushToWidget(screen: UserScreen(
      user: user,
    ), pop: (value) {
      _getRequest();
    });
  }

}
