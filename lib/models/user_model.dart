import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplechat/services/network_service.dart';

import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/image_widget.dart';

class UserModel {
  String id;
  String email;
  String username;
  String imgurl;
  String deviceid;
  String regdate;
  String updatedate;
  String expiredate;
  String type;
  String other;
  String gender;
  String birthday;
  String language;
  String comment;

  UserModel({
    this.id,
    this.email,
    this.username,
    this.imgurl,
    this.deviceid,
    this.regdate,
    this.updatedate,
    this.expiredate,
    this.type,
    this.other,
    this.birthday,
    this.gender,
    this.language,
    this.comment,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      username: map['username'],
      imgurl: map['imgurl'],
      deviceid: map['deviceid'],
      regdate: map['regdate'],
      updatedate: map['updatedate'],
      expiredate: map['expiredate'],
      type: map['type'],
      other: map['other'],
      gender: map['gender'],
      birthday: map['birthday'],
      language: map['language'],
      comment: map['comment'],
    );
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  bool isContainKey(String search) {
    if (search.isEmpty) return true;
    if (email.toLowerCase().contains(search.toLowerCase())) return true;
    if (username.toLowerCase().contains(search.toLowerCase())) return true;
    if (regdate.toLowerCase().contains(search.toLowerCase())) return true;
    if (type.toLowerCase().contains(search.toLowerCase())) return true;
    if (birthday.toLowerCase().contains(search.toLowerCase())) return true;
    if (gender.toLowerCase().contains(search.toLowerCase())) return true;
    if (language.toLowerCase().contains(search.toLowerCase())) return true;
    if (comment.toLowerCase().contains(search.toLowerCase())) return true;
    return false;
  }

  Widget itemSettingWidget() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(offsetBase),
      ),
      child: Container(
        padding: EdgeInsets.all(offsetBase),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
          gradient: getGradientColor(),
        ),
        child: Row(
          children: [
            CircleAvatarWidget(
              headurl: imgurl,
              size: 48.0,
            ),
            SizedBox(
              width: offsetBase,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: semiBold.copyWith(
                        fontSize: fontMd, color: Colors.white),
                  ),
                  SizedBox(
                    height: offsetXSm,
                  ),
                  Text(
                    email,
                    style: mediumText.copyWith(
                        fontSize: fontBase, color: Colors.white),
                    maxLines: 1,
                  ),
                  Text(
                    regdate,
                    style: mediumText.copyWith(
                        fontSize: fontBase, color: Colors.white),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_right_outlined,
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget itemSentWidget() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(offsetBase),
      ),
      child: Container(
        padding:
        EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetBase),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
          gradient: getGradientColor(color: Colors.grey),
        ),
        child: Row(
          children: [
            CircleAvatarWidget(
              headurl: imgurl,
              size: 36.0,
            ),
            SizedBox(
              width: offsetBase,
            ),
            Expanded(
              child: Text(
                username,
                style: semiBold.copyWith(fontSize: fontMd),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemRequestWidget(Function() send) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(offsetBase),
      ),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetBase),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
          gradient: getGradientColor(color: Colors.grey),
        ),
        child: Row(
          children: [
            CircleAvatarWidget(
              headurl: imgurl,
              size: 36.0,
            ),
            SizedBox(
              width: offsetBase,
            ),
            Expanded(
              child: Text(
                username,
                style: semiBold.copyWith(fontSize: fontMd),
              ),
            ),
            InkWell(
              onTap: () {
                send();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: offsetSm, vertical: offsetXSm),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.3),
                  border: Border.all(color: primaryColor, width: 0.3),
                  borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
                ),
                child: Text(
                  'Send',
                  style: regularText.copyWith(
                      fontSize: fontSm, color: primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemAcceptWidget(
      Function() accept, Function() cancel, Function() detail) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(offsetBase),
      ),
      child: InkWell(
        onTap: () {
          detail();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: offsetBase, vertical: offsetBase),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
            gradient: getGradientColor(color: primaryColor),
          ),
          child: Row(
            children: [
              CircleAvatarWidget(
                headurl: imgurl,
                size: 36.0,
              ),
              SizedBox(
                width: offsetBase,
              ),
              Expanded(
                child: Text(
                  username,
                  style: semiBold.copyWith(fontSize: fontMd),
                ),
              ),
              InkWell(
                onTap: () {
                  accept();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: offsetSm, vertical: offsetXSm),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.3),
                    border: Border.all(color: primaryColor, width: 0.3),
                    borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
                  ),
                  child: Text(
                    'Accept',
                    style: regularText.copyWith(
                        fontSize: fontSm, color: primaryColor),
                  ),
                ),
              ),
              SizedBox(
                width: offsetSm,
              ),
              InkWell(
                onTap: () {
                  cancel();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: offsetSm, vertical: offsetXSm),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.3),
                    border: Border.all(color: Colors.red, width: 0.3),
                    borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
                  ),
                  child: Text(
                    'Cancel',
                    style: regularText.copyWith(
                        fontSize: fontSm, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemFriendWidget({
    Function() chat,
    Function() voice,
    Function() video,
    Function() detail,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(offsetBase),
      ),
      child: InkWell(
        onTap: () {
          detail();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: offsetBase, vertical: offsetBase),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
            gradient: getGradientColor(color: getRandomColor()),
          ),
          child: Row(
            children: [
              CircleAvatarWidget(
                headurl: imgurl,
                size: 36.0,
              ),
              SizedBox(
                width: offsetBase,
              ),
              Expanded(
                child: Text(
                  username,
                  style:
                      semiBold.copyWith(fontSize: fontMd, color: Colors.white),
                ),
              ),
              InkWell(
                onTap: () {
                  chat();
                },
                child: Container(
                  width: 28.0,
                  height: 28.0,
                  padding: EdgeInsets.all(offsetSm),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.3),
                    border: Border.all(color: Colors.green, width: 0.3),
                    borderRadius: BorderRadius.all(Radius.circular(offsetXMd)),
                  ),
                  child: Icon(
                    Icons.chat,
                    color: Colors.green,
                    size: 12.0,
                  ),
                ),
              ),
              SizedBox(
                width: offsetBase,
              ),
              InkWell(
                onTap: () {
                  voice();
                },
                child: Container(
                  width: 28.0,
                  height: 28.0,
                  padding: EdgeInsets.all(offsetSm),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.3),
                    border: Border.all(color: Colors.green, width: 0.3),
                    borderRadius: BorderRadius.all(Radius.circular(offsetXMd)),
                  ),
                  child: Icon(
                    Icons.call,
                    color: Colors.green,
                    size: 12.0,
                  ),
                ),
              ),
              SizedBox(
                width: offsetBase,
              ),
              InkWell(
                onTap: () {
                  video();
                },
                child: Container(
                  width: 28.0,
                  height: 28.0,
                  padding: EdgeInsets.all(offsetSm),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.3),
                    border: Border.all(color: Colors.green, width: 0.3),
                    borderRadius: BorderRadius.all(Radius.circular(offsetXMd)),
                  ),
                  child: Icon(
                    Icons.videocam,
                    color: Colors.green,
                    size: 12.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'imgurl': imgurl,
      'deviceid': deviceid,
      'regdate': regdate,
      'updatedate': updatedate,
      'expiredate': expiredate,
      'type': type,
      'other': other,
      'gender': gender,
      'birthday': birthday,
      'language': language,
      'comment': comment,
    };
  }

  String toJson() => json.encode(toMap());

  Future<Map<String, dynamic>> request(BuildContext context) async {
    var param = {
      'id' : currentUser.id,
      'userid' : id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_send_request', param, isProgress: true);
    return resp;
  }
}

class FollowUserModel {
  UserModel user;
  String status;

  FollowUserModel({this.user, this.status});

  factory FollowUserModel.fromMap(Map<String, dynamic> map) {
    return new FollowUserModel(
      user: UserModel.fromMap(map['user']),
      status: map['status'] as String,
    );
  }

}
