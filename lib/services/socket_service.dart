import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:simplechat/services/notification_service.dart';
import 'package:simplechat/services/pref_service.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/params.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket socket;

  createSocketConnection() {
    socket = IO.io(SOCKET, <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.connect();

    socket.onConnect((_) async {
      print('socket connected');

      var param = {
        'id': 'user' + currentUser.id,
        'username': currentUser.username,
      };
      socket.emit('self', param);
    });

    this.socket.on("disconnect", (_) => print('Disconnected'));

    this.socket.on("request", (value) async {
      print("[receiver] request ===> ${value.toString()}");
      await PreferenceService().setRequestBadge(true);
      NotificationService.showNotification('Request', '${value['username']} just sent a friend request.\n Please check SimpleChat.', NotificationService.keyFriendRequest);
    });

    this.socket.on("accept", (value) async {
      print("[receiver] accept ===> ${value.toString()}");
      await PreferenceService().setFriendBadge(true);
      NotificationService.showNotification('Accept', '${value['username']} just accepted your request.\n Please check SimpleChat.', NotificationService.keyFriendAccept);
    });

    this.socket.on("unread", (value) async {
      print("[receiver] unread ===> ${value.toString()}");
      int badge = await PreferenceService().getRoomBadge(value['id']);
      print('badgeInfo ===> ${value['id']} : ${badge + 1}');
      await PreferenceService().setRoomBadge(value['id'], badge + 1);
      NotificationService.showNotification('Message', '${value['username']}\n${value['text']}', NotificationService.keyMessageChannel);
    });
  }

  void sendRequest(String userid) {
    print('[send] send request');
    var param = {
      'id': 'user' + currentUser.id,
      'username': currentUser.username,
      'userid': 'user' + userid,
    };
    socket.emit('request', param);
  }

  void acceptRequest(String userid, String roomID) {
    print('[send] submit accept');
    var param = {
      'id': 'user' + currentUser.id,
      'username': currentUser.username,
      'userid': 'user' + userid,
      'roomid': 'room' + roomID,
    };
    socket.emit('accept', param);
  }

  void sendChat(String type, String msg, String timestamp, String roomId, String userid, String shareRoom) {
    var param = {
      'type': type,
      'msg': msg,
      'id': 'user$userid',
      'roomid': 'room$roomId',
      'userid': 'user${currentUser.id}',
      'username': currentUser.username,
      'shareroom': shareRoom,
      'timestamp' : timestamp
    };
    print('[send] send message ===> ${param.toString()}');
    socket.emit('chatMessage', param);
  }

  void joinRoom({
    @required String roomId,
    @required Function(dynamic) message,
    @required Function(dynamic) typing,
    @required Function(dynamic) untyping,
    @required Function(dynamic) leaveRoom,
    @required Function(dynamic) joinChat,
  }) {
    var param = {
      'id': 'user' + currentUser.id,
      'username': currentUser.username,
      'room': roomId,
    };
    socket.emit('joinRoom', param);

    this.socket.on("message", (value) async {
      print("[receiver] message receiver ===> ${value.toString()}");
      message(value);
    });

    this.socket.on("typing", (value) async {
      print("[receiver] typing ===> ${value.toString()}");
      typing(value);
    });

    this.socket.on("untyping", (value) async {
      print("[receiver] untyping ===> ${value.toString()}");
      untyping(value);
    });

    this.socket.on("leaveRoom", (value) async {
      print("[receiver] leaveRoom ===> ${value.toString()}");
      leaveRoom(value);
    });

    this.socket.on("joinChat", (value) async {
      print("[receiver] joinChat ===> ${value.toString()}");
      joinChat(value);
    });
  }

  void leaveChat(String roomId, String userRoom, String userid) {
    var param = {
      'userid' : 'user${currentUser.id}',
      'room': 'room$roomId',
      'userRoom': 'room$userRoom',
      'toid': 'user$userid',
      'timestamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc()),
    };
    print("[send] leave chat send");
    socket.emit('leaveRoom', param);
  }

  void joinChat(String userRoom, String userid) {
    var param = {
      'userid' : 'user${currentUser.id}',
      'userRoom': 'room$userRoom',
      'toid': 'user$userid',
    };
    print("[send] join chat");
    socket.emit('joinChat', param);
  }

  void updateChatList({Function(dynamic) updateChatList}) {
    this.socket.on("updateChatList", (value) async {
      print("[receiver] updateChatList ===> ${value.toString()}");
      updateChatList(value);
    });
  }

}
