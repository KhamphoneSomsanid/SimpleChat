import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simplechat/main.dart';
import 'package:simplechat/screens/chat/voice_call_screen.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/image_widget.dart';

class VoiceRequestScreen extends StatefulWidget {
  final dynamic data;
  final bool isCall;

  const VoiceRequestScreen({
    Key key,
    @required this.data,
    this.isCall = false,
  }) : super(key: key);

  @override
  _VoiceRequestScreenState createState() => _VoiceRequestScreenState();
}

class _VoiceRequestScreenState extends State<VoiceRequestScreen> {

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      socketService.callRequest(accept: accept, decline: decline);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void accept(dynamic value) {
    NavigatorService(context).pushToWidget(
      screen: VoiceCallScreen(data: widget.data),
      replace: true,
    );
  }

  void decline(dynamic value) {
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetBase),
        child: Column(
          children: [
            SizedBox(height: offsetXLg * 2,),
            Text('Voice Calling', style: boldText.copyWith(fontSize: fontXLg),),
            SizedBox(height: offsetXLg, width: double.infinity,),
            CircleAvatarWidget(headurl: widget.data['text']),
            SizedBox(height: offsetXLg,),
            Text(widget.data['username'], style: semiBold.copyWith(fontSize: fontMd),),
            Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!widget.isCall) InkWell(
                  onTap: () {
                    socketService.sendCallAccept(widget.data['id']);
                    NavigatorService(context).pushToWidget(
                      screen: VoiceCallScreen(data: widget.data),
                      replace: true,
                    );
                  },
                  child: CircleIconWidget(
                    size: 56.0,
                    icon: Icon(Icons.call, color: Colors.green,)
                  ),
                ),
                if (!widget.isCall) SizedBox(width: offsetXLg * 2,),
                InkWell(
                  onTap: () {
                    socketService.sendCallDecline(widget.data['id']);
                    Navigator.of(context).pop(true);
                  },
                  child: CircleIconWidget(
                    size: 56.0,
                    icon: Icon(Icons.call_end, color: Colors.red,),
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: offsetXLg * 2,),
          ],
        ),
      ),
    );
  }
}
