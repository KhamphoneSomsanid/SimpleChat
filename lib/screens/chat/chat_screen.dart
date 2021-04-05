import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:simplechat/main.dart';
import 'package:simplechat/models/chat_user_model.dart';
import 'package:simplechat/models/media_model.dart';
import 'package:simplechat/models/message_model.dart';
import 'package:simplechat/screens/chat/chat_detail_screen.dart';
import 'package:simplechat/screens/chat/voice_request_screen.dart';
import 'package:simplechat/screens/post/post_feed_screen.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/image_service.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/constants.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var roomUsers = [];
  var messages = [];
  MediaModel mediaModel;
  var msgController = TextEditingController();

  StreamController<List<dynamic>> messageController =
      new StreamController.broadcast();
  StreamController<String> activeController = new StreamController.broadcast();

  ScrollController _scrollController;

  var isAttachment = false;

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
      case 'TEXT':
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
      case 'IMAGE':
      case 'VIDEO':
        for (var user in roomUsers) {
          if ('user${user.user.id}' == value['id']) {
            MessageModel model = MessageModel(
              userid: user.user.id,
              username: user.user.username,
              imgurl: user.user.imgurl,
              roomid: widget.room.id,
              type: value['type'].toString(),
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

  _typing(dynamic value) {}

  _untyping(dynamic value) {}

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
      'id': currentUser.id,
      'roomid': widget.room.id,
      'status': 'AWAY',
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
      'roomid': widget.room.id,
      'userid': currentUser.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_detail', param, isProgress: true);
    if (resp['ret'] == 10000) {
      roomUsers.clear();
      roomUsers =
          (resp['users'].map((item) => ChatUserModel.fromMap(item)).toList());

      messages.clear();
      messages =
          (resp['msgs'].map((item) => MessageModel.fromMap(item)).toList());
      messages.sort((b, a) => a.regdate.compareTo(b.regdate));

      for (var user in roomUsers) {
        if (user.user.id == currentUser.id) {
          socketService.joinRoom(
            roomId: 'room' + user.roomid,
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
        key: _scaffoldKey,
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
                    style: boldText.copyWith(
                        fontSize: fontMd, color: primaryColor),
                  ),
                  SizedBox(
                    height: offsetXSm,
                  ),
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
                            UserStatusWidget(
                              status: status,
                            ),
                            SizedBox(
                              width: offsetSm,
                            ),
                            Text(
                              title,
                              style: mediumText.copyWith(fontSize: fontSm),
                            ),
                          ],
                        );
                      })
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
                  color: Colors.grey.withOpacity(0.1),
                  padding:
                      EdgeInsets.only(top: 0, left: offsetSm, right: offsetSm),
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
                                return snapshot.data[i].cell(resend: () {
                                  var msgData = snapshot.data[i];
                                  msgData.isError = false;
                                  if (msgData.type == 'TEXT' ||
                                      msgData.type == 'LOCATION') {
                                    send(msgData);
                                  } else {
                                    sendFeed(msgData);
                                  }
                                }, detail: () {
                                  var msgData = snapshot.data[i];
                                  MediaModel mediaModel = MediaModel(
                                      url: msgData.content, type: msgData.type);
                                  NavigatorService(context).pushToWidget(
                                      screen:
                                          ChatDetailScreen(data: mediaModel));
                                }, callRequest: () {
                                  onCallRequest();
                                });
                              });
                    },
                  ),
                ),
              ),
              isAttachment
                  ? Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: offsetBase, vertical: offsetSm),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                          ),
                          Spacer(),
                          Container(
                            width: 200 - offsetBase,
                            height: 200 - offsetBase,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(offsetBase)),
                              boxShadow: [containerShadow()],
                            ),
                            child: Stack(
                              children: [
                                _getMediaWidget(200 - offsetBase, action: () {
                                  NavigatorService(context).pushToWidget(
                                      screen: PostFeedScreen(
                                    data: mediaModel.file,
                                    type: mediaModel.type,
                                  ));
                                }),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isAttachment = false;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: offsetXSm, top: offsetSm),
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32 / 2.0)),
                                      ),
                                      child: Center(
                                          child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 32 / 2,
                                      )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              MessageModel model = MessageModel(
                                userid: currentUser.id,
                                username: currentUser.username,
                                imgurl: currentUser.imgurl,
                                roomid: widget.room.id,
                                type: mediaModel.type,
                                regdate: StringService.getCurrentUTCTime(),
                                file: mediaModel.file,
                                thumbnail: mediaModel.thumbnail,
                                isSending: true,
                              );
                              sendFeed(model);
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(48 / 2)),
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 48 / 2,
                              )),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 56,
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(
                            width: offsetBase,
                          ),
                          InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                if (!appSettingInfo['isChatRecord']) {
                                  DialogService(context).showSnackbar(
                                      notSupport, _scaffoldKey,
                                      type: SnackBarType.ERROR);
                                  return;
                                }
                              },
                              child: SvgPicture.asset(
                                  'assets/icons/ic_record.svg')),
                          SizedBox(
                            width: offsetBase,
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(vertical: offsetSm),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: offsetSm),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  child: TextField(
                                    controller: msgController,
                                    textInputAction: TextInputAction.send,
                                    style:
                                        mediumText.copyWith(fontSize: fontMd),
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
                                          regdate:
                                              StringService.getCurrentUTCTime(),
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
                          SizedBox(
                            width: offsetBase,
                          ),
                          InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                if (!appSettingInfo['isChatEmoji']) {
                                  DialogService(context).showSnackbar(
                                      notSupport, _scaffoldKey,
                                      type: SnackBarType.ERROR);
                                  return;
                                }
                              },
                              child:
                                  SvgPicture.asset('assets/icons/ic_emoj.svg')),
                          SizedBox(
                            width: offsetBase,
                          ),
                          InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                if (!appSettingInfo['isChatAdd']) {
                                  DialogService(context).showSnackbar(
                                      notSupport, _scaffoldKey,
                                      type: SnackBarType.ERROR);
                                  return;
                                }
                                DialogService(context).showTypeDialog(
                                  chooseImage: () {
                                    Navigator.of(context).pop();
                                    showPickerDialog(isVideo: false);
                                  },
                                  chooseVideo: () {
                                    Navigator.of(context).pop();
                                    showPickerDialog(isVideo: true);
                                  },
                                  chooseDocument: () {
                                    Navigator.of(context).pop();
                                    DialogService(context).showSnackbar(
                                        notSupport, _scaffoldKey,
                                        type: SnackBarType.ERROR);
                                  },
                                  chooseLocation: () {
                                    Navigator.of(context).pop();
                                    DialogService(context).showSnackbar(
                                        notSupport, _scaffoldKey,
                                        type: SnackBarType.ERROR);
                                  },
                                  chooseLink: () {
                                    Navigator.of(context).pop();
                                    DialogService(context).showSnackbar(
                                        notSupport, _scaffoldKey,
                                        type: SnackBarType.ERROR);
                                  },
                                );
                              },
                              child:
                                  SvgPicture.asset('assets/icons/ic_add.svg')),
                          SizedBox(
                            width: offsetBase,
                          ),
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
    setState(() {});

    try {
      var resp = await NetworkService(context)
          .ajax('chat_add_message', model.toMap(), isProgress: false);
      if (resp['ret'] == 10000) {
        model.isSending = false;
        messageController.add(messages);

        for (var user in roomUsers) {
          if (user.user.id == currentUser.id) continue;
          socketService.sendChat('Text', model.content, model.regdate,
              user.roomid, user.user.id, widget.room.id);
        }
      }
    } catch (e) {
      model.isError = true;
      model.isSending = false;
      messageController.add(messages);
    }
  }

  void sendFeed(model) async {
    messages.insert(0, model);
    messageController.add(messages);
    msgController.text = '';
    setState(() {
      isAttachment = false;
    });

    String url = 'https://' + DOMAIN + '/Backend/chat_add_message_feed';
    var request = http.MultipartRequest("POST", Uri.parse(url));

    request.fields['userid'] = model.userid;
    request.fields['roomid'] = model.roomid;
    request.fields['regdate'] = model.regdate;
    request.fields['type'] = model.type;
    request.fields['thumbnail'] = model.thumbnail;

    if (model.file != null) {
      var pic = await http.MultipartFile.fromPath("data", model.file.path);
      request.files.add(pic);
    }

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print('responseString ===> $responseString');
    try {
      var jsonData = json.decode(responseString);
      if (jsonData['ret'] == 10000) {
        model.isSending = false;
        messageController.add(messages);

        for (var user in roomUsers) {
          if (user.user.id == currentUser.id) continue;
          socketService.sendChat('Image', 'just sent ${model.type} to you.',
              model.regdate, user.roomid, user.user.id, widget.room.id);
        }
      }
    } catch (e) {
      model.isError = true;
      model.isSending = false;
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
            child: Text(
              'Call Method',
              style: semiBold.copyWith(fontSize: fontMd),
            )),
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
                    'id': selUser.id,
                    'text': selUser.imgurl,
                    'username': selUser.username,
                  };
                  socketService.sendCallRequest(selUser.id, 'voice');
                  NavigatorService(context).pushToWidget(
                      screen: VoiceRequestScreen(
                    data: data,
                    isCall: true,
                  ));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.call,
                      color: blueColor,
                    ),
                    SizedBox(
                      width: offsetBase,
                    ),
                    Text(
                      'Voice Call',
                      style: mediumText.copyWith(fontSize: fontBase),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: offsetBase,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.videocam,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: offsetBase,
                  ),
                  Text(
                    'Video Call',
                    style: mediumText.copyWith(fontSize: fontBase),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  void showPickerDialog({bool isVideo = false}) {
    var pickers = [
      {
        'icon': Icons.image,
        'title': 'From Gallery',
        'source': ImageSource.gallery,
        'color': primaryColor
      },
      {
        'icon': Icons.videocam,
        'title': 'From Camera',
        'source': ImageSource.camera,
        'color': blueColor
      },
    ];
    DialogService(context).showCustomModalBottomSheet(
      titleWidget: Container(
        padding: EdgeInsets.all(offsetBase),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: boldText.copyWith(fontSize: fontBase, color: Colors.red),
              ),
            ),
            Text(
              'Choose Media',
              style: boldText.copyWith(fontSize: fontLg),
            ),
            Text(
              'Cancel',
              style: boldText.copyWith(fontSize: fontBase, color: Colors.white),
            ),
          ],
        ),
      ),
      bodyWidget: Container(
        padding: EdgeInsets.all(offsetBase),
        child: Column(
          children: [
            Text(
              'Please choose the image picker source.',
              style: mediumText.copyWith(fontSize: fontMd),
            ),
            SizedBox(
              height: offsetMd,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: offsetLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var data in pickers)
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        if (isVideo) {
                          _vidPicker(data['source']);
                        } else {
                          _imgPicker(data['source']);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: offsetBase, vertical: offsetBase),
                        decoration: BoxDecoration(
                          gradient: getGradientColor(color: data['color']),
                          borderRadius:
                              BorderRadius.all(Radius.circular(offsetBase)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              data['icon'],
                              size: 36,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: offsetSm,
                            ),
                            Text(
                              data['title'],
                              style: semiBold.copyWith(
                                  fontSize: fontBase, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _imgPicker(ImageSource source) async {
    PickedFile image = await ImagePicker().getImage(
        source: source, imageQuality: 50, maxWidth: 4000, maxHeight: 4000);

    String base64Thumbnail = await ImageService()
        .getThumbnailBase64FromImage(File(image.path), width: 320, height: 320);

    mediaModel = MediaModel(
      userid: currentUser.id,
      kind: 'CHAT',
      type: 'IMAGE',
      thumbnail: base64Thumbnail,
      file: File(image.path),
      other: '',
    );

    setState(() {
      isAttachment = true;
    });
  }

  _vidPicker(ImageSource source) async {
    PickedFile video = await ImagePicker().getVideo(source: source);

    String base64Thumbnail = await ImageService()
        .getThumbnailBase64FromVideo(File(video.path), width: 320, height: 320);

    mediaModel = MediaModel(
      userid: currentUser.id,
      kind: 'CHAT',
      type: 'VIDEO',
      thumbnail: base64Thumbnail,
      file: File(video.path),
      other: '',
    );

    setState(() {
      isAttachment = true;
    });
  }

  Widget _getMediaWidget(double size, {Function() action}) {
    switch (mediaModel.type) {
      case 'IMAGE':
      case 'VIDEO':
        return InkWell(
          onTap: action,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: Image.memory(
                      base64.decode(mediaModel.thumbnail),
                      fit: BoxFit.cover,
                      width: size,
                      height: size,
                    ),
                  ),
                  if (mediaModel.type == 'VIDEO')
                    Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius:
                              BorderRadius.all(Radius.circular(48 / 2)),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 48 / 2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
    }
    return Container();
  }
}
