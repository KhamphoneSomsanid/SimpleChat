import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/common_widget.dart';
import 'package:simplechat/widgets/image_widget.dart';
import 'package:simplechat/widgets/user_status_widget.dart';

class RoomModel {
  String id;
  String title;
  String imgurl;
  String creatorid;
  String type;
  String regdate;
  String status;
  String other;

  String lastname;
  String lastmsg;
  String lasttime;

  RoomModel(
      {this.id,
      this.title,
      this.imgurl,
      this.creatorid,
      this.type,
      this.regdate,
      this.status,
      this.other,
      this.lastname,
      this.lastmsg,
      this.lasttime});

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'],
      title: map['title'],
      imgurl: map['imgurl'],
      creatorid: map['creatorid'],
      type: map['type'],
      regdate: map['regdate'],
      status: map['status'],
      other: map['other'],
      lastname: map['lastname'],
      lastmsg: map['lastmsg'],
      lasttime: map['lasttime'],
    );
  }

  bool isContainKey(String key) {
    if (title.toLowerCase().contains(key.toLowerCase())) return true;
    if (type.toLowerCase().contains(key.toLowerCase())) return true;
    if (regdate.toLowerCase().contains(key.toLowerCase())) return true;
    if (status.toLowerCase().contains(key.toLowerCase())) return true;
    if (lastname.toLowerCase().contains(key.toLowerCase())) return true;
    if (lastmsg.toLowerCase().contains(key.toLowerCase())) return true;
    if (lasttime.toLowerCase().contains(key.toLowerCase())) return true;
    return false;
  }

  Widget itemRoom({
    int badge = 0,
    Function() chat,
  }) {
    var status = USERSTATUS.Online;
    if (this.status == 'AWAY') status = USERSTATUS.Away;
    if (this.status == 'OFFLINE') status = USERSTATUS.Offline;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: offsetBase,
            right: offsetBase,
            top: offsetBase,
            bottom: offsetSm,
          ),
          child: InkWell(
            onTap: () {
              chat();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  child: Stack(
                    children: [
                      CircleAvatarWidget(
                        headurl: imgurl,
                        size: 40.0,
                      ),
                      if (this.status != 'NONE')
                        Align(
                          alignment: Alignment.bottomRight,
                          child: UserStatusWidget(status: status),
                        )
                    ],
                  ),
                ),
                SizedBox(
                  width: offsetBase,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: boldText.copyWith(fontSize: fontBase),
                      ),
                      SizedBox(
                        height: offsetXSm,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lastmsg,
                              maxLines: 1,
                              style: regularText.copyWith(fontSize: fontSm),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      StringService.getCurrentTimeValue(lasttime),
                      style: regularText.copyWith(fontSize: fontSm),
                    ),
                    SizedBox(
                      height: offsetSm,
                    ),
                    if (badge != null && badge > 0)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.all(Radius.circular(offsetBase)),
                        ),
                        child: Text(
                          '$badge',
                          style: regularText.copyWith(
                              fontSize: fontXSm, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        DividerWidget(
          padding: EdgeInsets.only(left: 64),
        ),
      ],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imgurl': imgurl,
      'creatorid': creatorid,
      'type': type,
      'regdate': regdate,
      'status': status,
      'other': other,
      'lastname': lastname,
      'lastmsg': lastmsg,
      'lasttime': lasttime,
    };
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source));
}
