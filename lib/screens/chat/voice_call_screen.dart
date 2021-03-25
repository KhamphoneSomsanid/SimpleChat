import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:simplechat/main.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/image_widget.dart';
import 'package:sound_stream/sound_stream.dart';

class VoiceCallScreen extends StatefulWidget {
  final dynamic data;

  const VoiceCallScreen({
    Key key,
    @required this.data
  }) : super(key: key);

  @override
  _VoiceCallScreenState createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  RecorderStream _recorder = RecorderStream();
  PlayerStream _player = PlayerStream();

  StreamSubscription _recorderStatus;
  StreamSubscription _playerStatus;
  StreamSubscription _audioStream;

  bool isRecording = false;

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      socketService.callStream(close: close, stream: stream);
    });
    initAudio();
  }

  void close(dynamic value) {
    _recorderStatus?.cancel();
    _playerStatus?.cancel();
    _audioStream?.cancel();

    _recorder.stop();
    _player.stop();

    Navigator.of(context).pop(false);
  }

  void stream(dynamic value) {
    List<int> list = value['text'].codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    _player.writeChunk(bytes);
  }

  Future<void> initAudio() async {
    _recorderStatus = _recorder.status.listen((status) async {
      print('recorder ===> ${status.toString()}');
      if (status == SoundStreamStatus.Playing) {
        isRecording = true;
      }
      if (status == SoundStreamStatus.Initialized) {
        await _recorder.start();
      }
    });

    _audioStream = _recorder.audioStream.listen((data) {
      socketService.sendCallStream(widget.data['id'], String.fromCharCodes(data));
    });

    _playerStatus = _player.status.listen((status) async {
      print('player ===> ${status.toString()}');
      if (isRecording && status == SoundStreamStatus.Initialized) {
        await _player.start();
      }
    });

    await _recorder.initialize(sampleRate: 4000);
    await _player.initialize(sampleRate: 4000);
  }

  @override
  void dispose() {
    // if (_recorder != null) _recorder.dispose();
    // if (_player != null) _player.dispose();

    super.dispose();
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
            InkWell(
              onTap: () {
                _recorderStatus?.cancel();
                _playerStatus?.cancel();
                _audioStream?.cancel();

                _recorder.stop();
                _player.stop();

                socketService.sendCallClose(widget.data['id']);
                Navigator.of(context).pop(true);
              },
              child: CircleIconWidget(
                size: 56.0,
                icon: Icon(Icons.call_end, color: Colors.red,),
                color: Colors.red,
              ),
            ),
            SizedBox(height: offsetXLg * 2,),
          ],
        ),
      ),
    );
  }
}
