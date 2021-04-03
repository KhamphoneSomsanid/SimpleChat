import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/image_widget.dart';

class MessageModel {

  String id;
  String userid;
  String username;
  String imgurl;
  String roomid;
  String regdate;
  String type;
  String content;
  String other;
  String thumbnail;
  File file;
  bool isSending;
  bool isError;

  MessageModel(
      {this.id,
      this.userid,
      this.username,
      this.imgurl,
      this.roomid,
      this.regdate,
      this.type,
      this.content,
      this.other,
      this.thumbnail,
      this.file,
      this.isSending = false,
      this.isError = false,
      });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return new MessageModel(
      id: map['id'] as String,
      userid: map['userid'] as String,
      username: map['username'] as String,
      imgurl: map['imgurl'] as String,
      roomid: map['roomid'] as String,
      regdate: map['regdate'] as String,
      type: map['type'] as String,
      content: map['content'] as String,
      other: map['other'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userid': this.userid,
      'roomid': this.roomid,
      'regdate': this.regdate,
      'type': this.type,
      'content': this.content,
      'thumbnail': this.thumbnail??'',
    };
  }

  Widget cell({
    Function() resend,
    Function() callRequest,
    Function() detail,
  }) {
    var corner = 8.0;
    var paddingHorizontal = offsetBase;
    var paddingVertical = offsetSm + offsetXSm;

    var sizeMedia = 180.0;
    var paddingMedia = 2.0;

    switch (type) {
      case 'TEXT':
        return userid == currentUser.id ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              SizedBox(width: offsetXLg,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(corner),
                                    bottomLeft: Radius.circular(corner),
                                    bottomRight: Radius.circular(corner),
                                  ),
                                ),
                                child: Text(content, style: semiBold.copyWith(fontSize: fontBase, color: Colors.white),),
                              ),
                            ],
                          ),
                        ),
                        if (isSending || isError) SizedBox(width: offsetSm,),
                        if (isSending) CupertinoActivityIndicator(),
                        if (isError) InkWell(
                            onTap: () {
                              resend();
                            },
                            child: Icon(Icons.refresh, color: Colors.red,)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) : Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  callRequest();
                },
                child: CircleAvatarWidget(
                  headurl: imgurl,
                  size: 36.0,
                ),
              ),
              SizedBox(width: offsetSm,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(username + ' ' + StringService.getChatTime(regdate), style: semiBold.copyWith(fontSize: fontXSm),),
                    ),
                    SizedBox(height: offsetXSm,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(corner),
                          bottomLeft: Radius.circular(corner),
                          bottomRight: Radius.circular(corner),
                        ),
                      ),
                      child: Text(content, style: semiBold.copyWith(fontSize: fontBase),),
                    ),
                  ],
                ),
              ),
              SizedBox(width: offsetXLg,),
            ],
          ),
        );
      case 'IMAGE':
      case 'VIDEO':
        return userid == currentUser.id
            ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              SizedBox(width: offsetXLg,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: sizeMedia, height: sizeMedia,
                                padding: EdgeInsets.all(paddingMedia),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(corner),
                                    bottomLeft: Radius.circular(corner),
                                    bottomRight: Radius.circular(corner),
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    if (detail != null) detail();
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(corner - paddingMedia)),
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: file == null? Image.network(other,
                                              fit: BoxFit.cover,
                                              width: (sizeMedia - paddingMedia * 2),
                                              height: (sizeMedia - paddingMedia * 2),
                                            ) : Image.memory(base64.decode(thumbnail),
                                              fit: BoxFit.cover,
                                              width: (sizeMedia - paddingMedia * 2),
                                              height: (sizeMedia - paddingMedia * 2),
                                            ),
                                          ),
                                          if (type == 'VIDEO') Center(
                                            child: Container(
                                              width: 48, height: 48,
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.5),
                                                borderRadius: BorderRadius.all(Radius.circular(48 / 2)),
                                              ),
                                              child: Icon(Icons.play_arrow, color: Colors.white, size: 48 / 2,),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSending || isError) SizedBox(width: offsetSm,),
                        if (isSending) CupertinoActivityIndicator(),
                        if (isError) InkWell(
                            onTap: () {
                              resend();
                            },
                            child: Icon(Icons.refresh, color: Colors.red,)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
            : Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  callRequest();
                },
                child: CircleAvatarWidget(
                  headurl: imgurl,
                  size: 36.0,
                ),
              ),
              SizedBox(width: offsetSm,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(username + ' ' + StringService.getChatTime(regdate), style: semiBold.copyWith(fontSize: fontXSm),),
                    ),
                    SizedBox(height: offsetXSm,),
                    Container(
                      width: sizeMedia,
                      height: sizeMedia,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(corner),
                          bottomLeft: Radius.circular(corner),
                          bottomRight: Radius.circular(corner),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (detail != null) detail();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(corner - paddingMedia)),
                          child: Container(
                            child: Stack(
                              children: [
                                Center(
                                  child: file == null? Image.network(other,
                                    fit: BoxFit.cover,
                                    width: (sizeMedia - paddingMedia * 2),
                                    height: (sizeMedia - paddingMedia * 2),
                                  ) : Image.memory(base64.decode(thumbnail),
                                    fit: BoxFit.cover,
                                    width: (sizeMedia - paddingMedia * 2),
                                    height: (sizeMedia - paddingMedia * 2),
                                  ),
                                ),
                                if (type == 'VIDEO') Center(
                                  child: Container(
                                    width: 48, height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.all(Radius.circular(48 / 2)),
                                    ),
                                    child: Icon(Icons.play_arrow, color: Colors.white, size: 48 / 2,),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: offsetXLg,),
            ],
          ),
        );
    }
    return Container();
  }

}