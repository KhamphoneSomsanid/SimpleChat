import 'dart:convert';

class ReviewModel {
  String id;
  String postid;
  String userid;
  String type;
  String regdate;
  String other;

  ReviewModel({
    this.id,
    this.postid,
    this.userid,
    this.type,
    this.regdate,
    this.other,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postid': postid,
      'userid': userid,
      'type': type,
      'regdate': regdate,
      'other': other,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'],
      postid: map['postid'],
      userid: map['userid'],
      type: map['type'],
      regdate: map['regdate'],
      other: map['other'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source));
}
