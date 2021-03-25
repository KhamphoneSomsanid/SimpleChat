import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:simplechat/services/notification_service.dart';
import 'package:simplechat/services/pref_service.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/params.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket socket;

  createSocketConnection({Function(dynamic) request}) {
    socket = IO.io(SOCKET, <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.connect();

    socket.onConnect((_) async {
      print('socket connected');

      var paramSelf = {
        'id': 'user' + currentUser.id,
        'username': currentUser.username,
      };
      socket.emit('self', paramSelf);

      var paramCall = {
        'id': 'call' + currentUser.id,
        'username': currentUser.username,
      };
      socket.emit('call', paramCall);

      this.socket.on("call_request", (value) async {
        print("[receiver] calling request ===> ${value.toString()}");
        request(value);
      });
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
  
  void callRequest({
    @required Function(dynamic) accept,
    @required Function(dynamic) decline,
  }) {
    this.socket.on("call_accept", (value) async {
      print("[receiver] calling accept ===> ${value.toString()}");
      accept(value);
    });

    this.socket.on("call_decline", (value) async {
      print("[receiver] calling decline ===> ${value.toString()}");
      decline(value);
    });
  }
  
  void callStream({
    @required Function(dynamic) close,
    @required Function(dynamic) stream,
  }) {
    this.socket.on("call_close", (value) async {
      print("[receiver] calling close ===> ${value.toString()}");
      close(value);
    });

    this.socket.on("call_stream", (value) async {
      print("[receiver] calling stream");
      stream(value);
    });
  }

  void sendCallRequest(String userid, String type) {
    print('[send] send call request');
    var param = {
      'userid': 'call' + userid,
      'id' : currentUser.id,
      'username': currentUser.username,
      'imgurl': currentUser.imgurl,
      'type': type,
      'datetime': StringService.getCurrentUTCTime(),
    };
    socket.emit('call_request', param);
  }

  void sendCallDecline(String userid) {
    print('[send] send call decline');
    var param = {
      'userid': 'call' + userid,
      'datetime': StringService.getCurrentUTCTime(),
    };
    socket.emit('call_decline', param);
  }

  void sendCallAccept(String userid) {
    print('[send] send call accept');
    var param = {
      'userid': 'call' + userid,
      'datetime': StringService.getCurrentUTCTime(),
    };
    socket.emit('call_accept', param);
  }

  void sendCallClose(String userid) {
    print('[send] send call close');
    var param = {
      'userid': 'call' + userid,
      'datetime': StringService.getCurrentUTCTime(),
    };
    socket.emit('call_close', param);
  }

  void sendCallStream(String userid, String stream) {
    var param = {
      'userid': 'call' + userid,
      'stream' : stream,
      'datetime': StringService.getCurrentUTCTime(),
    };
    socket.emit('call_stream', param);
  }

  void leaveChat(String roomId, String userRoom, String userid, String status) {
    var param = {
      'userid' : 'user${currentUser.id}',
      'room': 'room$roomId',
      'userRoom': 'room$userRoom',
      'toid': 'user$userid',
      'status': status,
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
