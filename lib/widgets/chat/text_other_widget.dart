import 'package:flutter/material.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/image_widget.dart';

class ChatTextOtherWidget extends StatelessWidget {
  const ChatTextOtherWidget({
    Key key,
    @required this.imgurl,
    @required this.username,
    @required this.regdate,
    @required this.paddingHorizontal,
    @required this.paddingVertical,
    @required this.corner,
    @required this.content,
    @required this.callRequest,
  }) : super(key: key);

  final String imgurl;
  final String username;
  final String regdate;
  final double paddingHorizontal;
  final double paddingVertical;
  final double corner;
  final String content;
  final Function() callRequest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              callRequest();
            },
            child: CircleAvatarWidget(
              headurl: imgurl,
              size: 36.0,
            ),
          ),
          SizedBox(
            width: offsetSm,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    username + ' ' + StringService.getChatTime(regdate),
                    style: semiBold.copyWith(fontSize: fontXSm),
                  ),
                ),
                SizedBox(
                  height: offsetXSm,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontal, vertical: paddingVertical),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(corner),
                      bottomLeft: Radius.circular(corner),
                      bottomRight: Radius.circular(corner),
                    ),
                  ),
                  child: Text(
                    content,
                    style: semiBold.copyWith(fontSize: fontBase),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: offsetXLg,
          ),
        ],
      ),
    );
  }
}
