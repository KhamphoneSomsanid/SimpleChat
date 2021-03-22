import 'package:simplechat/services/network_service.dart';

class PostModel {
  String id;
  String userid;
  String content;
  String regdate;
  String tag;
  String other;

  PostModel({
    this.id,
    this.userid,
    this.content,
    this.regdate,
    this.tag,
    this.other,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return new PostModel(
      id: map['id'] as String,
      userid: map['userid'] as String,
      content: map['content'] as String,
      regdate: map['regdate'] as String,
      tag: map['tag'] as String,
      other: map['other'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userid': this.userid,
      'content': this.content,
      'regdate': this.regdate,
      'tag': this.tag,
      'other': this.other,
    };
  }

  upload() async {
    var param = toMap();
    var resp = await NetworkService(null)
        .ajax('chat_add_post', param, isProgress: false);
    return resp;
  }
}