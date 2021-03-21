import 'package:flutter/material.dart';

enum USERSTATUS {
  Online,
  Away,
  Offline,
}

class UserStatusWidget extends StatelessWidget {
  const UserStatusWidget({
    Key key,
    this.status = USERSTATUS.Online,
  }) : super(key: key);

  final USERSTATUS status;

  @override
  Widget build(BuildContext context) {
    Color color = status == USERSTATUS.Online
        ? Colors.green
        : status == USERSTATUS.Away ? Colors.orangeAccent : Colors.grey;
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      ),
    );
  }
}
