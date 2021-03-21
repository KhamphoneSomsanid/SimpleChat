import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplechat/models/user_model.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/image_widget.dart';

class StoryModel {
  String id;
  String userid;
  String username;
  String userimg;
  String content;
  String regdate;
  String type;

  StoryModel(
      {this.id,
      this.userid,
      this.username,
      this.userimg,
      this.content,
      this.regdate,
      this.type});

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return new StoryModel(
      id: map['id'] as String,
      userid: map['userid'] as String,
      username: map['username'] as String,
      userimg: map['userimg'] as String,
      content: map['content'] as String,
      regdate: map['regdate'] as String,
      type: map['type'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userid': this.userid,
      'username': this.username,
      'userimg': this.userimg,
      'content': this.content,
      'regdate': this.regdate,
      'type': this.type,
    };
  }

  Widget addCell() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: offsetXSm, vertical: offsetXSm),
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 1,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
        child: Stack(
          children: [
            Image.network(currentUser.imgurl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, widget, event) {
                return event == null
                    ? widget
                    : Center(
                      child: Image.asset('assets/icons/ic_logo.png', color: Colors.grey, width: 48, fit: BoxFit.fitWidth,),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 40.0, height: 40.0,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(24.0))
                  ),
                  child: Center(
                    child: Icon(Icons.add, color: Colors.white,),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.5),
                padding: EdgeInsets.all(offsetSm),
                child: Text('Add to\nStory',
                  style: boldText.copyWith(fontSize: fontXSm, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class ExtraStoryModel {
  UserModel user;
  List<dynamic> list;

  ExtraStoryModel({this.user, this.list});

  factory ExtraStoryModel.fromMap(Map<String, dynamic> map) {
    List<dynamic> stories = [];
    stories = (map['list'].map((item) => StoryModel.fromMap(item)).toList());
    stories.sort((a, b) => a.regdate.compareTo(b.regdate));

    return new ExtraStoryModel(
      user: UserModel.fromMap(map['user']),
      list: stories,
    );
  }

  Widget cell({
    Widget content,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: offsetXSm, vertical: offsetXSm),
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
        child: Stack(
          children: [
            content == null? Container(
              color: getRandomColor(),
              width: double.infinity, height: double.infinity,
            ) : content,
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 40.0, height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(24.0))
                  ),
                  child: CircleAvatarWidget(
                    headurl: user.imgurl,
                    size: 40,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: double.infinity,
                height: 40,
                color: Colors.black.withOpacity(0.5),
                padding: EdgeInsets.all(offsetSm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.username,
                      maxLines: 1,
                      style: boldText.copyWith(fontSize: fontXSm, color: Colors.white),
                    ),
                    Text(StringService.getCurrentTimeValue(list.last.regdate),
                      maxLines: 1,
                      style: mediumText.copyWith(fontSize: fontXSm, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}