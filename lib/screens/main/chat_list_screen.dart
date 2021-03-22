import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/main.dart';
import 'package:simplechat/models/room_model.dart';
import 'package:simplechat/screens/chat/chat_screen.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/pref_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/common_widget.dart';
import 'package:simplechat/widgets/empty_widget.dart';
import 'package:simplechat/widgets/textfield_widget.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  var rooms = [];
  var showRooms = [];
  var badgeInfo = {};
  var searchController = TextEditingController();

  bool isUpdating = false;

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _getRoom();
    });

    searchController.addListener(() {
      filterData();
    });

    socketService.updateChatList(updateChatList: _updateChatList);
  }

  _updateChatList(value) {
    Timer.run(() {
      _getRoom();
    });
  }

  _getRoom() async {
    setState(() {
      isUpdating = true;
    });

    var param = {
      'id' : currentUser.id,
    };
    var resp = await NetworkService(null)
        .ajax('chat_room', param, isProgress: false);
    if (resp['ret'] == 10000) {
      rooms.clear();
      rooms = (resp['result'].map((item) => RoomModel.fromMap(item)).toList());
      rooms.sort((b, a) => a.lasttime.compareTo(b.lasttime));

      for (var room in rooms) {
        var badge = await PreferenceService().getRoomBadge(room.id);
        badgeInfo[room.id] = badge;
      }
      print('badgeInfo ===> ${badgeInfo.toString()}');

      filterData();
    }
  }

  filterData() {
    String search = searchController.text;
    showRooms.clear();
    for (var room in rooms) {
      if (room.isContainKey(search)) {
        showRooms.add(room);
      }
    }
    setState(() {isUpdating = false;});
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
        appBar: MainBarWidget(
          titleIcon: Container(
            padding: EdgeInsets.all(offsetBase),
            child: SvgPicture.asset(
              'assets/icons/ic_chat.svg',
              color: primaryColor,
            ),
          ),
          titleString: 'Chats',
        ),
        body: Container(
          padding: EdgeInsets.all(offsetBase),
          child: Column(
            children: [
              UpdateWidget(
                isUpdating: isUpdating,
                title: 'Updating now ...',
              ),
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
                child: showRooms.isEmpty
                    ? EmptyWidget(
                  title: 'You have not any chat room. After accept friend, please try it again.',
                ) : ListView.builder(
                    itemCount: showRooms.length,
                    itemBuilder: (context, i) {
                      return showRooms[i].itemRoom(
                        badge: badgeInfo[showRooms[i].id],
                        chat: () {
                          PreferenceService().setRoomBadge(showRooms[i].id, 0);
                          NavigatorService(context).pushToWidget(
                              screen: ChatScreen(
                                room: showRooms[i],
                              ),
                            pop: (val) {
                              _getRoom();
                            }
                          );
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
}
