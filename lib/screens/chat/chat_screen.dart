import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simplechat/main.dart';
import 'package:simplechat/models/chat_user_model.dart';
import 'package:simplechat/models/message_model.dart';
import 'package:simplechat/screens/chat/voice_request_screen.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/user_status_widget.dart';

class ChatScreen extends StatefulWidget {
  final dynamic room;

  const ChatScreen({
    Key key,
    this.room,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var roomUsers = [];
  var messages = [];

  var msgController = TextEditingController();

  StreamController<List<dynamic>> messageController = new StreamController.broadcast();
  StreamController<String> activeController = new StreamController.broadcast();

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    Timer.run(() async {
      await _getData();

      for (var user in roomUsers) {
        if (user.user.id != currentUser.id) {
          _joinChatSocket(user);
          activeController.add(user.status);
        }
      }
    });

    messageController.add(messages);
  }

  _message(dynamic value) {
    switch (value['type'].toString().toUpperCase()) {
      case 'TEXT' :
        for (var user in roomUsers) {
          if ('user${user.user.id}' == value['id']) {
            MessageModel model = MessageModel(
              userid: user.user.id,
              username: user.user.username,
              imgurl: user.user.imgurl,
              roomid: widget.room.id,
              type: 'TEXT',
              regdate: value['time'],
              content: value['text'],
            );
            messages.insert(0, model);
            messageController.add(messages);
          }
        }
        break;
    }
  }

  _typing(dynamic value) {

  }

  _untyping(dynamic value) {

  }

  _leaveRoom(dynamic value) {
    activeController.add(value['text']);
  }

  _joinChat(dynamic value) {
    activeController.add('ONLINE');
  }

  _joinChatSocket(user) {
    socketService.joinChat(user.roomid, user.user.id);
  }

  _leaveChat() async {
    var param = {
      'id' : currentUser.id,
      'roomid' : widget.room.id,
      'status' : 'AWAY',
    };
    await NetworkService(context).ajax('chat_leave', param, isProgress: false);
    String userRoom = '';
    for (var user in roomUsers) {
      if (user.user.id == currentUser.id) {
        userRoom = user.roomid;
        break;
      }
    }
    for (var user in roomUsers) {
      if (user.user.id != currentUser.id) {
        socketService.leaveChat(userRoom, user.roomid, user.user.id, 'AWAY');
      }
    }
  }

  @override
  void dispose() {
    _leaveChat();
    msgController.dispose();
    super.dispose();
  }

  Future<void> _getData() async {
    var param = {
      'roomid' : widget.room.id,
      'userid' : currentUser.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_detail', param, isProgress: true);
    if (resp['ret'] == 10000) {
      roomUsers.clear();
      roomUsers = (resp['users'].map((item) => ChatUserModel.fromMap(item)).toList());

      messages.clear();
      messages = (resp['msgs'].map((item) => MessageModel.fromMap(item)).toList());
      messages.sort((b, a) => a.regdate.compareTo(b.regdate));

      for (var user in roomUsers) {
        if (user.user.id == currentUser.id) {
          socketService.joinRoom(roomId: 'room' + user.roomid,
            message: _message,
            typing: _typing,
            untyping: _untyping,
            leaveRoom: _leaveRoom,
            joinChat: _joinChat,
          );
        }
      }
      messageController.add(messages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MainBarWidget(
          background: Colors.white,
          titleWidget: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringService.formatName(widget.room.title),
                    style: boldText.copyWith(fontSize: fontMd, color: primaryColor),
                  ),
                  SizedBox(height: offsetXSm,),
                  StreamBuilder(
                    stream: activeController.stream,
                    builder: (context, snap) {
                      var status = USERSTATUS.Online;
                      var title = 'Active now';
                      if (snap.data == 'AWAY') {
                        status = USERSTATUS.Away;
                        title = 'Away';
                      }
                      if (snap.data == 'OFFLINE') {
                        status = USERSTATUS.Offline;
                        title = 'Offline';
                      }
                      return Row(
                      children: [
                        UserStatusWidget(status: status,),
                        SizedBox(width: offsetSm,),
                        Text(
                          title,
                          style: mediumText.copyWith(fontSize: fontSm),
                        ),
                      ],
                    );
                    }
                  )
                ],
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 0, left: offsetSm, right: offsetSm),
                  color: Colors.grey.withOpacity(0.1),
                  child: StreamBuilder(
                    stream: messageController.stream,
                    builder: (context, snapshot) {
                      return snapshot.data == null
                          ? Container()
                          : ListView.builder(
                          reverse: true,
                          controller: _scrollController,
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return snapshot.data[i].cell(
                              resend: () {
                                var msgData = snapshot.data[i];
                                msgData.isError = false;
                                send(msgData);
                              },
                              callRequest: () {
                                onCallRequest();
                              }
                            );
                          }
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 56,
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(width: offsetBase,),
                    SvgPicture.asset('assets/icons/ic_record.svg'),
                    SizedBox(width: offsetBase,),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: offsetSm),
                            padding: EdgeInsets.symmetric(horizontal: offsetSm),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.all(Radius.circular(8.0))
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: TextField(
                              controller: msgController,
                              autofocus: true,
                              textInputAction: TextInputAction.send,
                              style: mediumText.copyWith(fontSize: fontMd),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                              onSubmitted: (value) {
                                String msg = msgController.text;
                                if (msg.isNotEmpty) {
                                  MessageModel model = MessageModel(
                                    userid: currentUser.id,
                                    username: currentUser.username,
                                    imgurl: currentUser.imgurl,
                                    roomid: widget.room.id,
                                    type: 'TEXT',
                                    regdate: StringService.getCurrentUTCTime(),
                                    content: msg,
                                    isSending: true,
                                  );
                                  send(model);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: offsetBase,),
                    SvgPicture.asset('assets/icons/ic_emoj.svg'),
                    SizedBox(width: offsetBase,),
                    SvgPicture.asset('assets/icons/ic_add.svg'),
                    SizedBox(width: offsetBase,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void send(model) async {
    messages.insert(0, model);
    messageController.add(messages);
    msgController.text = '';
    setState(() {

    });

    try {
      var resp = await NetworkService(context)
          .ajax('chat_add_message', model.toMap(), isProgress: false);
      if (resp['ret'] == 10000) {
        model.isSending = false;
        messageController.add(messages);

        for (var user in roomUsers) {
          if (user.user.id == currentUser.id) continue;
          socketService.sendChat('Text', model.content, model.regdate, user.roomid, user.user.id, widget.room.id);
        }
      }
    } catch(e) {
      model.isError = true;
      messageController.add(messages);
    }
  }

  void scrollToBottom() {
    final bottomOffset = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      bottomOffset,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  void onCallRequest() {
    DialogService(context).showCustomModalBottomSheet(
        titleWidget: Container(
          padding: EdgeInsets.all(offsetBase),
            child: Text('Call Method', style: semiBold.copyWith(fontSize: fontMd),)),
        bodyWidget: Container(
          padding: EdgeInsets.all(offsetBase),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  var selUser;
                  for (var user in roomUsers) {
                    if (user.user.id != currentUser.id) {
                      selUser = user.user;
                      break;
                    }
                  }
                  var data = {
                    'id' : selUser.id,
                    'text' : selUser.imgurl,
                    'username' : selUser.username,
                  };
                  socketService.sendCallRequest(selUser.id, 'voice');
                  NavigatorService(context).pushToWidget(screen: VoiceRequestScreen(
                    data: data,
                    isCall: true,
                  ));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.call, color: blueColor,),
                    SizedBox(width: offsetBase,),
                    Text('Voice Call', style: mediumText.copyWith(fontSize: fontBase),)
                  ],
                ),
              ),
              SizedBox(height: offsetBase,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.videocam, color: primaryColor,),
                  SizedBox(width: offsetBase,),
                  Text('Video Call', style: mediumText.copyWith(fontSize: fontBase),)
                ],
              ),
            ],
          ),
        )
    );
  }

}
