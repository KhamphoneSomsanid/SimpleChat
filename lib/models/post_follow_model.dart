import 'dart:convert';

class PostFollowModel {
  String id;
  String postid;
  String userid;
  String regdate;
  String other;

  PostFollowModel({
    this.id,
    this.postid,
    this.userid,
    this.regdate,
    this.other,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postid': postid,
      'userid': userid,
      'regdate': regdate,
      'other': other,
    };
  }

  factory PostFollowModel.fromMap(Map<String, dynamic> map) {
    return PostFollowModel(
      id: map['id'],
      postid: map['postid'],
      userid: map['userid'],
      regdate: map['regdate'],
      other: map['other'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PostFollowModel.fromJson(String source) =>
      PostFollowModel.fromMap(json.decode(source));
}
