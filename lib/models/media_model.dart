import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:http/http.dart' as http;

class MediaModel {
  String id;
  String userid;
  String mediaid;
  String url;
  String thumbnail;
  String content;
  String kind;
  String type;
  String regdate;
  String other;

  File file;

  MediaModel(
      {this.id,
      this.userid,
      this.mediaid,
      this.url,
      this.thumbnail,
      this.content,
      this.kind,
      this.type,
      this.regdate,
      this.other,
      this.file});

  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return new MediaModel(
      id: map['id'] as String,
      userid: map['userid'] as String,
      mediaid: map['mediaid'] as String,
      url: map['url'] as String,
      thumbnail: map['thumbnail'] as String,
      content: map['content'] as String,
      kind: map['kind'] as String,
      type: map['type'] as String,
      regdate: map['regdate'] as String,
      other: map['other'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userid': this.userid,
      'mediaid': this.mediaid,
      'content': this.content,
      'thumbnail': this.thumbnail ?? '',
      'kind': this.kind,
      'type': this.type,
      'regdate': this.regdate,
    };
  }

  Widget mediaWidget(Widget preview, {Function() remove}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(offsetBase))),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
            child: preview,
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                remove();
              },
              child: Container(
                margin: EdgeInsets.only(right: offsetSm, top: offsetSm),
                padding: EdgeInsets.all(offsetXSm),
                width: 24.0,
                height: 24.0,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cellMediaWidget({bool isOne = false, int type = 0}) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
              (isOne == false && (type == 3 || type == 5)) ? offsetBase : 0),
          topRight: Radius.circular(
              (isOne == false && (type == 2 || type == 4)) ? offsetBase : 0),
          bottomLeft: Radius.circular(
              (isOne == false && (type == 1 || type == 5)) ? offsetBase : 0),
          bottomRight: Radius.circular(
              (isOne == false && (type == 0 || type == 4)) ? offsetBase : 0),
        ),
        child: Image.network(
          thumbnail,
          fit: BoxFit.cover,
          loadingBuilder: (context, widget, event) {
            return event == null
                ? widget
                : Center(
                    child: Image.asset(
                      'assets/icons/ic_logo.png',
                      color: Colors.grey,
                      width: 56,
                      fit: BoxFit.fitWidth,
                    ),
                  );
          },
        ),
      ),
    );
  }

  Future<dynamic> upload() async {
    String url = 'https://' + DOMAIN + '/Backend/chat_upload';
    var request = http.MultipartRequest("POST", Uri.parse(url));

    request.fields['userid'] = userid;
    request.fields['mediaid'] = mediaid;
    request.fields['content'] = content;
    request.fields['kind'] = kind;
    request.fields['type'] = type;
    request.fields['regdate'] = regdate;

    if (file != null) {
      request.fields['thumbnail'] = thumbnail;

      var pic = await http.MultipartFile.fromPath("image", file.path);
      request.files.add(pic);
    }

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    return json.decode(responseString);
  }
}
