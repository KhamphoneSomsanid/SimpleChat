import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';

class ChatTextSelfWidget extends StatelessWidget {
  const ChatTextSelfWidget({
    Key key,
    @required this.paddingHorizontal,
    @required this.paddingVertical,
    @required this.corner,
    @required this.content,
    @required this.isSending,
    @required this.isError,
    @required this.resend,
  }) : super(key: key);

  final double paddingHorizontal;
  final double paddingVertical;
  final double corner;
  final String content;
  final bool isSending;
  final bool isError;
  final Function() resend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: offsetXLg,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontal,
                                vertical: paddingVertical),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(corner),
                                bottomLeft: Radius.circular(corner),
                                bottomRight: Radius.circular(corner),
                              ),
                            ),
                            child: Text(
                              content,
                              style: semiBold.copyWith(
                                  fontSize: fontBase, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSending || isError)
                      SizedBox(
                        width: offsetSm,
                      ),
                    if (isSending) CupertinoActivityIndicator(),
                    if (isError)
                      InkWell(
                          onTap: () {
                            resend();
                          },
                          child: Icon(
                            Icons.refresh,
                            color: Colors.red,
                          )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
