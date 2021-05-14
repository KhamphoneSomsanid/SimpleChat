import 'package:simplechat/models/nearby_model.dart';

class NearbyProjectModel {
  String id;
  String buyerid;
  NearbyModel buyer;
  List<NearbyModel> sellers = [];

  String title;
  String content;
  String method;
  String price;
  String during;
  List<String> attachments = [];
  String opendate;
  String closedate;

  NearbyProjectModel(
      {this.id,
      this.buyerid,
      this.buyer,
      this.sellers,
      this.title,
      this.content,
      this.method,
      this.price,
      this.during,
      this.attachments,
      this.opendate,
      this.closedate});

  factory NearbyProjectModel.fromMap(Map<String, dynamic> map) {
    return new NearbyProjectModel(
      id: map['id'] as String,
      buyerid: map['buyerid'] as String,
      buyer: map['buyer'] as NearbyModel,
      sellers: map['sellers'] as List<NearbyModel>,
      title: map['title'] as String,
      content: map['content'] as String,
      method: map['method'] as String,
      price: map['price'] as String,
      during: map['during'] as String,
      attachments: map['attachments'] as List<String>,
      opendate: map['opendate'] as String,
      closedate: map['closedate'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'buyerid': this.buyerid,
      'buyer': this.buyer.toMap(),
      'sellers': this.sellers,
      'title': this.title,
      'content': this.content,
      'method': this.method,
      'price': this.price,
      'during': this.during,
      'attachments': this.attachments,
      'opendate': this.opendate,
      'closedate': this.closedate,
    };
  }
}
