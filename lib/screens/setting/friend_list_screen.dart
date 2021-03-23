import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simplechat/models/user_model.dart';
import 'package:simplechat/screens/setting/user_screen.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/empty_widget.dart';
import 'package:simplechat/widgets/textfield_widget.dart';

class FriendListScreen extends StatefulWidget {
  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var friends = [];
  var showUsers = [];
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _getFriends();
    });

    searchController.addListener(() {
      filterData();
    });
  }

  _getFriends() async {
    var param = {
      'id' : currentUser.id,
    };

    var resp = await NetworkService(context)
        .ajax('chat_friend', param, isProgress: true);
    if (resp['ret'] == 10000) {
      friends.clear();
      friends = (resp['result'].map((item) => UserModel.fromMap(item)).toList());

      filterData();
    }
  }

  filterData() {
    String search = searchController.text;
    showUsers.clear();
    for (var user in friends) {
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
        resizeToAvoidBottomInset: false,
        appBar: MainBarWidget(
          titleString: 'Friend List',
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
                  title: 'Your friend is not existed yet. After accept friend, please try it again.',
                ) : ListView.builder(
                    itemCount: showUsers.length,
                    itemBuilder: (context, i) {
                      return showUsers[i].itemFriendWidget(
                        detail: () => _detail(showUsers[i]),
                        chat: () => _chat(showUsers[i]),
                        voice: () => _voice(showUsers[i]),
                        video: () => _video(showUsers[i]),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _detail(dynamic user) {
    NavigatorService(context).pushToWidget(screen: UserScreen(
      user: user,
    ), pop: (value) {
      _getFriends();
    });
  }

  void _chat(dynamic user) async{

  }

  void _voice(dynamic user) async{

  }

  void _video(dynamic user) async{

  }

}
