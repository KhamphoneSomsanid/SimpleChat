import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplechat/utils/constants.dart';

class CircleAvatarWidget extends StatelessWidget {
  final String headurl;
  final double size;
  final double borderWidth;

  const CircleAvatarWidget({
    Key key,
    @required this.headurl,
    this.size = 120,
    this.borderWidth = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size)),
          border: Border.all(color: Colors.white, width: borderWidth)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.network(
          headurl.isEmpty ? avatarUrl : headurl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingBuilder: (context, widget, event) {
            return event == null
                ? widget
                : Center(
                    child: Image.asset(
                      'assets/icons/ic_logo.png',
                      color: Colors.grey,
                      width: size / 2,
                      fit: BoxFit.fitWidth,
                    ),
                  );
          },
          errorBuilder: (context, url, error) => Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: size,
          ),
        ),
      ),
    );
  }
}
