import 'dart:io';

import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/string_service.dart';

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
      this.other});

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
      'kind': this.kind,
      'type': this.type,
      'regdate': this.regdate,
    };
  }

  Future<dynamic> upload({File file, String thumbnail}) async {
    var param = toMap();
    if (file != null) {
      param['base64'] = StringService.getBase64FromFile(file);
      param['thumbnail'] = thumbnail;
    }
    var resp = await NetworkService(null)
        .ajax('chat_upload', param, isProgress: false);
    return resp;
  }

}