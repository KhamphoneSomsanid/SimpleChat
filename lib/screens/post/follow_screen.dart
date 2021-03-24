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

class FollowScreen extends StatefulWidget {
  final String postid;

  const FollowScreen({
    Key key,
    @required this.postid
  }) : super(key: key);

  @override
  _FollowScreenState createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<FollowUserModel> followUsers = [];
  List<FollowUserModel> showUsers = [];
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _getData();
    });
  }

  void _getData() async {
    var param = {
      'postid' : widget.postid,
      'userid' : currentUser.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_post_follow', param, isProgress: true);
    if (resp['ret'] == 10000) {
      followUsers.clear();
      for (var json in resp['result']) {
        FollowUserModel model = FollowUserModel.fromMap(json);
        followUsers.add(model);
      }
    }

    filterData();
  }

  filterData() {
    String search = searchController.text;
    showUsers.clear();
    for (var user in followUsers) {
      if (user.user.isContainKey(search)) {
        showUsers.add(user);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MainBarWidget(
          titleString: 'Follows (${followUsers.length})',
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetBase),
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
              Expanded(
                child: showUsers.isEmpty
                    ? EmptyWidget(
                  title: 'The follow users are not existed yet.',
                ) : ListView.builder(
                  itemCount: showUsers.length,
                    itemBuilder: (context, i) {
                      if (showUsers[i].user.id == currentUser.id) return showUsers[i].user.itemSentWidget();
                      switch (showUsers[i].status) {
                        case '0':
                          return showUsers[i].user.itemRequestWidget(() => _request(showUsers[i].user));
                        case '1':
                          return showUsers[i].user.itemAcceptWidget(
                            () {
                              // _accept(showUsers[i]);
                            }, () {
                              // _cancel(showUsers[i]);
                            }, () {
                              // _detail(showUsers[i]);
                            }
                          );
                        case '2':
                          return showUsers[i].user.itemSentWidget();
                        case '3':
                          return showUsers[i].user.itemFriendWidget(
                            detail: () => _detail(showUsers[i].user),
                            chat: () => _chat(showUsers[i].user),
                            voice: () => _voice(showUsers[i].user),
                            video: () => _video(showUsers[i].user),
                          );
                      }
                      return Container();
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _request(UserModel user) async {
    var resp = await user.request(context);
    if (resp['ret'] == 10000) {
      DialogService(context).showSnackbar(resp['msg'], _scaffoldKey);
      socketService.sendRequest(user.id);
      setState(() {
        searchController.text = '';
        _getData();
      });
    } else {
      DialogService(context).showSnackbar(resp['msg'], _scaffoldKey, type: SnackBarType.WARING);
    }
  }

  void _detail(UserModel user) {
    NavigatorService(context).pushToWidget(screen: UserScreen(
      user: user,
    ), pop: (value) {
      _getData();
    });
  }

  void _chat(UserModel user) async{

  }

  void _voice(UserModel user) async{

  }

  void _video(UserModel user) async{

  }

}
