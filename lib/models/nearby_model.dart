import 'package:simplechat/models/user_model.dart';

class NearbyModel {
  String id;
  String userid;
  String type;
  String regdate;
  String coin;
  String other;
  UserModel user;

  NearbyModel(
      {this.id,
      this.userid,
      this.type,
      this.regdate,
      this.coin,
      this.other,
      this.user});

  factory NearbyModel.fromMap(Map<String, dynamic> map) {
    return new NearbyModel(
      id: map['id'] as String,
      userid: map['userid'] as String,
      type: map['type'] as String,
      regdate: map['regdate'] as String,
      coin: map['coin'] as String,
      other: map['other'] as String,
      user: UserModel.fromMap(map['user']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'userid': this.userid,
      'type': this.type,
      'regdate': this.regdate,
      'coin': this.coin,
      'other': this.other,
      'user': user.toJson(),
    };
  }
}
