class NotificationModel {
  String id;
  String username;
  String content;
  String regdate;

  NotificationModel(this.id, this.username, this.content, this.regdate);


  bool isContainKey(String key) {
    return true;
  }

}