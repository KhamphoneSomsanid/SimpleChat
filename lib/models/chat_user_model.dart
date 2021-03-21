import 'package:simplechat/models/user_model.dart';

class ChatUserModel {
  String roomid;
  String status;
  UserModel user;

  ChatUserModel({this.roomid, this.status, this.user});

  factory ChatUserModel.fromMap(Map<String, dynamic> map) {
    return new ChatUserModel(
      roomid: map['roomid'] as String,
      status: map['status'] as String,
      user: UserModel.fromMap(map['user']),
    );
  }

}