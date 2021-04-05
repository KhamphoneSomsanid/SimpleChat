import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/chat/media_other_widget.dart';
import 'package:simplechat/widgets/chat/media_self_widget.dart';
import 'package:simplechat/widgets/chat/text_other_widget.dart';
import 'package:simplechat/widgets/chat/text_self_widget.dart';
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

  MessageModel({
    this.id,
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
      'thumbnail': this.thumbnail ?? '',
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
        return userid == currentUser.id
            ? ChatTextSelfWidget(
                paddingHorizontal: paddingHorizontal,
                paddingVertical: paddingVertical,
                corner: corner,
                content: content,
                isSending: isSending,
                isError: isError,
                resend: resend)
            : ChatTextOtherWidget(
                imgurl: imgurl,
                username: username,
                regdate: regdate,
                paddingHorizontal: paddingHorizontal,
                paddingVertical: paddingVertical,
                corner: corner,
                content: content,
                callRequest: callRequest,
              );
      case 'IMAGE':
      case 'VIDEO':
        var optionSize = 32.0;
        return userid == currentUser.id
            ? ChatMediaSelfWidget(
                sizeMedia: sizeMedia,
                paddingMedia: paddingMedia,
                corner: corner,
                file: file,
                other: other,
                thumbnail: thumbnail,
                type: type,
                optionSize: optionSize,
                isSending: isSending,
                isError: isError,
                detail: detail,
                resend: resend,
              )
            : ChatMediaOtherWidget(
                imgurl: imgurl,
                username: username,
                regdate: regdate,
                sizeMedia: sizeMedia,
                corner: corner,
                paddingMedia: paddingMedia,
                file: file,
                other: other,
                thumbnail: thumbnail,
                type: type,
                optionSize: optionSize,
                detail: detail,
                callRequest: callRequest,
              );
    }
    return Container();
  }
}
