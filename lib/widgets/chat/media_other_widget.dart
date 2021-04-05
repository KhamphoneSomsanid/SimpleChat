import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/image_widget.dart';

class ChatMediaOtherWidget extends StatefulWidget {
  const ChatMediaOtherWidget({
    Key key,
    @required this.imgurl,
    @required this.username,
    @required this.regdate,
    @required this.sizeMedia,
    @required this.corner,
    @required this.paddingMedia,
    @required this.file,
    @required this.other,
    @required this.thumbnail,
    @required this.type,
    @required this.optionSize,
    @required this.detail,
    @required this.callRequest,
  }) : super(key: key);

  final String imgurl;
  final String username;
  final String regdate;
  final double sizeMedia;
  final double corner;
  final double paddingMedia;
  final File file;
  final String other;
  final String thumbnail;
  final String type;
  final double optionSize;
  final Function() detail;
  final Function() callRequest;

  @override
  _ChatMediaOtherWidgetState createState() => _ChatMediaOtherWidgetState();
}

class _ChatMediaOtherWidgetState extends State<ChatMediaOtherWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              widget.callRequest();
            },
            child: CircleAvatarWidget(
              headurl: widget.imgurl,
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
                    widget.username +
                        ' ' +
                        StringService.getChatTime(widget.regdate),
                    style: semiBold.copyWith(fontSize: fontXSm),
                  ),
                ),
                SizedBox(
                  height: offsetXSm,
                ),
                Container(
                  width: widget.sizeMedia,
                  height: widget.sizeMedia,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(widget.corner),
                      bottomLeft: Radius.circular(widget.corner),
                      bottomRight: Radius.circular(widget.corner),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (widget.detail != null) widget.detail();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                          Radius.circular(widget.corner - widget.paddingMedia)),
                      child: Container(
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
                                    color: Colors.black.withOpacity(0.5),
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
                                      margin: EdgeInsets.only(right: offsetSm),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  widget.optionSize / 2.0))),
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
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  widget.optionSize / 2.0))),
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
          SizedBox(
            width: offsetXLg,
          ),
        ],
      ),
    );
  }
}
