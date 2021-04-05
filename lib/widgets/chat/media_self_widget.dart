import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplechat/utils/dimens.dart';

class ChatMediaSelfWidget extends StatefulWidget {
  const ChatMediaSelfWidget({
    Key key,
    @required this.sizeMedia,
    @required this.paddingMedia,
    @required this.corner,
    @required this.file,
    @required this.other,
    @required this.thumbnail,
    @required this.type,
    @required this.optionSize,
    @required this.isSending,
    @required this.isError,
    @required this.detail,
    @required this.resend,
  }) : super(key: key);

  final double sizeMedia;
  final double paddingMedia;
  final double corner;
  final File file;
  final String other;
  final String thumbnail;
  final String type;
  final double optionSize;
  final bool isSending;
  final bool isError;
  final Function() detail;
  final Function() resend;

  @override
  _ChatMediaSelfWidgetState createState() => _ChatMediaSelfWidgetState();
}

class _ChatMediaSelfWidgetState extends State<ChatMediaSelfWidget> {
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
                            width: widget.sizeMedia,
                            height: widget.sizeMedia,
                            padding: EdgeInsets.all(widget.paddingMedia),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(widget.corner),
                                bottomLeft: Radius.circular(widget.corner),
                                bottomRight: Radius.circular(widget.corner),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (widget.detail != null) widget.detail();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    widget.corner - widget.paddingMedia)),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: widget.file == null
                                            ? Image.network(
                                                widget.other,
                                                fit: BoxFit.cover,
                                                width: (widget.sizeMedia -
                                                    widget.paddingMedia * 2),
                                                height: (widget.sizeMedia -
                                                    widget.paddingMedia * 2),
                                              )
                                            : Image.memory(
                                                base64.decode(widget.thumbnail),
                                                fit: BoxFit.cover,
                                                width: (widget.sizeMedia -
                                                    widget.paddingMedia * 2),
                                                height: (widget.sizeMedia -
                                                    widget.paddingMedia * 2),
                                              ),
                                      ),
                                      if (widget.type == 'VIDEO')
                                        Center(
                                          child: Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(48 / 2)),
                                            ),
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                              size: 48 / 2,
                                            ),
                                          ),
                                        ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          padding: EdgeInsets.all(offsetSm),
                                          child: Row(
                                            children: [
                                              Spacer(),
                                              Container(
                                                width: widget.optionSize,
                                                height: widget.optionSize,
                                                margin: EdgeInsets.only(
                                                    right: offsetSm),
                                                decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            widget.optionSize /
                                                                2.0))),
                                                child: Icon(
                                                  Icons.share,
                                                  color: Colors.white,
                                                  size: 12.0,
                                                ),
                                              ),
                                              Container(
                                                width: widget.optionSize,
                                                height: widget.optionSize,
                                                decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            widget.optionSize /
                                                                2.0))),
                                                child: Icon(
                                                  Icons.download_sharp,
                                                  color: Colors.white,
                                                  size: 12.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.isSending || widget.isError)
                      SizedBox(
                        width: offsetSm,
                      ),
                    if (widget.isSending) CupertinoActivityIndicator(),
                    if (widget.isError)
                      InkWell(
                          onTap: () {
                            widget.resend();
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
