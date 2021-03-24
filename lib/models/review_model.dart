import 'dart:convert';

class ReviewModel {
  String id;
  String reviewid;
  String userid;
  String type;
  String kind;
  String regdate;
  String other;

  ReviewModel({
    this.id,
    this.reviewid,
    this.userid,
    this.type,
    this.kind,
    this.regdate,
    this.other,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reviewid': reviewid,
      'userid': userid,
      'type': type,
      'kind': kind,
      'regdate': regdate,
      'other': other,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'],
      reviewid: map['reviewid'],
      userid: map['userid'],
      type: map['type'],
      kind: map['kind'],
      regdate: map['regdate'],
      other: map['other'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source));
}
