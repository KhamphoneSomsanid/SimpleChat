import 'dart:convert';

class CommentModel {
  String id;
  String postid;
  String userid;
  String commentid;
  String content;
  String regdate;
  String other;

  CommentModel({
    this.id,
    this.postid,
    this.userid,
    this.commentid,
    this.content,
    this.regdate,
    this.other,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postid': postid,
      'userid': userid,
      'commentid': commentid,
      'content': content,
      'regdate': regdate,
      'other': other,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      postid: map['postid'],
      userid: map['userid'],
      commentid: map['commentid'],
      content: map['content'],
      regdate: map['regdate'],
      other: map['other'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));
}
