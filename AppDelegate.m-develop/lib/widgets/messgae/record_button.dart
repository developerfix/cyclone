import 'dart:async';
import 'dart:io' as io;

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_record_plugin/flutter_record_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audio_wave/audio_wave.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';


import 'ImagesAnimation.dart';

OverlayEntry mOverlayEntry;

String mButtonText = "Hold to sound";
String mCenterTipText = "";
final LocalFileSystem mLocalFileSystem = new LocalFileSystem();

double startY = 0.0;
double endY = 0.0;
double offsetY = 0.0;

int mSatrtRecordTime = 0;

/**
 * 最短录音时间
 **/
int MIN_INTERVAL_TIME = 1000;

String voiceIco = "assets/images/ic_volume_1.png";

List<String> _assetList = new List();

bool showAnim = true;

typedef void OnAudioCallBack(File mAudioFile, int duration);

class RecordButton extends StatefulWidget {
  final OnAudioCallBack onAudioCallBack;

  const RecordButton({
    Key key,
    this.onAudioCallBack,
  }) : super(key: key);

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

 onEndddd(){
  print("ennnnnnnnnnnnnnnfffff");
}

void onend(){
  print("this is end");
}

///显示录音悬浮布局
buildOverLayView(BuildContext context) {
  Timer _timer;
  int _start = 10;

  CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  controller = CountdownTimerController(endTime: endTime,onEnd: onEndddd);



  if (mOverlayEntry == null) {
    mOverlayEntry = new OverlayEntry(builder: (content) {
      return Positioned(
        top: MediaQuery.of(context).size.height * 0.5 - 80,
        left: MediaQuery.of(context).size.width * 0.5 - 80,
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            child: Opacity(
              opacity: 0.8,
              child: Container(
                width: 200,
                height: 160,
                decoration: BoxDecoration(
                  color: Color(0xff979699),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Column(
                  children: <Widget>[

                    CountdownTimer(

                      onEnd: onEndddd,
                      controller: controller,
                      endTime: endTime,
                    ),
                    Container(
                      child: Center(
                        child: AudioWave(
                          height: 32,
                          width: 88,
                          spacing: 2.5,
                          animation: true,
                          bars: [
                            AudioWaveBar(
                                height: 10, color: Colors.lightBlueAccent),
                            AudioWaveBar(height: 30, color: Colors.blue),
                            AudioWaveBar(height: 70, color: Colors.black),
                            AudioWaveBar(height: 40),
                            AudioWaveBar(height: 20, color: Colors.orange),
                            AudioWaveBar(
                                height: 10, color: Colors.lightBlueAccent),
                            AudioWaveBar(height: 30, color: Colors.blue),
                            AudioWaveBar(height: 70, color: Colors.black),
                            AudioWaveBar(height: 40),
                            AudioWaveBar(height: 20, color: Colors.orange),
                            AudioWaveBar(
                                height: 10, color: Colors.lightBlueAccent),
                            AudioWaveBar(height: 30, color: Colors.blue),
                            AudioWaveBar(height: 70, color: Colors.black),
                            AudioWaveBar(height: 40),
                            AudioWaveBar(height: 20, color: Colors.orange),
                            AudioWaveBar(
                                height: 10, color: Colors.lightBlueAccent),
                            AudioWaveBar(height: 30, color: Colors.blue),
                            AudioWaveBar(height: 70, color: Colors.black),
                            AudioWaveBar(height: 40),
                            AudioWaveBar(height: 20, color: Colors.orange),
                          ],
                        ),
                      ),
                      height: 100,
                    ),

                    // Container(
                    //     margin: EdgeInsets.only(top: 10),
                    //     child: showAnim
                    //         ? VoiceAnimationImage(
                    //             _assetList,
                    //             width: 100,
                    //             height: 100,
                    //             isStop: true,
                    //           )
                    //         : new Image.asset(
                    //             voiceIco,
                    //             width: 100,
                    //             height: 100,
                    //           )),
                    Container(
//                      padding: EdgeInsets.only(right: 20, left: 20, top: 0),
                      child: Text(
                        mCenterTipText,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
    Overlay.of(context).insert(mOverlayEntry);
  }
}

Map<int, Image> imageCaches = new Map();

class _RecordButtonState extends State<RecordButton> {
//  Recording _recording = new Recording();

  startRecord() async {
    print("开始录音");
    io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
    String path = appDocDirectory.path +
        '/' +
        new DateTime.now().millisecondsSinceEpoch.toString();
    print("开始录音路径: $path");
    await FlutterRecordPlugin.start(
        path: path, audioOutputFormat: AudioOutputFormat.AAC);
    bool isRecording = await FlutterRecordPlugin.isRecording;
  }

  cancelRecord() async {
    var recording = await FlutterRecordPlugin.stop();
    File file = mLocalFileSystem.file(recording.path);
    file.delete();
    print("取消录音删除文件成功!");
    if (mOverlayEntry != null) {
      mOverlayEntry.remove();
      mOverlayEntry = null;
    }
    //  }
    //   });
    setState(() {
      //_recording = recording;
    });
  }

 void  completeRecord() async {

    print("completeRecord:::");

    int intervalTime =
        new DateTime.now().millisecondsSinceEpoch - mSatrtRecordTime;
    if (intervalTime < MIN_INTERVAL_TIME) {
      print("录音时间太短");
      mCenterTipText = "The recording time is too short";
      voiceIco = "assets/images/ic_volume_wraning.png";
      showAnim = false;
      mButtonText = "Hold to record";
      mOverlayEntry.markNeedsBuild();
      var recording = await FlutterRecordPlugin.stop();
      bool isRecording = await FlutterRecordPlugin.isRecording;
      File file = mLocalFileSystem.file(recording.path);
      file.delete();
      print("录音时间太短:删除文件成功!");
      if (mOverlayEntry != null) {
        Future.delayed(Duration(milliseconds: 500), () {
          mOverlayEntry.remove();
          mOverlayEntry = null;
        });
      }
    } else {
      print("录音完成");

      var recording = await FlutterRecordPlugin.stop();
      print("Stop recording: ${recording.path}");
      File file = mLocalFileSystem.file(recording.path);
      print("  File length: ${recording.duration.inSeconds}");

      if (mOverlayEntry != null) {
        mOverlayEntry.remove();
        mOverlayEntry = null;
      }
      widget.onAudioCallBack?.call(file, recording.duration.inSeconds);
    }
  }

  bool flag = true; // member variable

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _assetList.add("assets/images/ic_volume_1.png");
    _assetList.add("assets/images/ic_volume_2.png");
    _assetList.add("assets/images/ic_volume_3.png");
    _assetList.add("assets/images/ic_volume_4.png");
    _assetList.add("assets/images/ic_volume_5.png");
    _assetList.add("assets/images/ic_volume_6.png");
    _assetList.add("assets/images/ic_volume_7.png");
    _assetList.add("assets/images/ic_volume_8.png");
  }

  double startY = 0.0;
  double endY = 0.0;
  double offsetY = 0.0;

  @override
  Widget build(BuildContext context) {
    //buildGestureOverLayView(context);
    return Container(
      /* width: MediaQuery.of(context).size.width,*/
      //height: MediaQuery.of(context).size.height,
      //   color: Colors.deepOrange,
      child: GestureDetector(
        onVerticalDragStart: (details) {
          if (flag) {
            flag = false;
            Future.delayed(const Duration(milliseconds: 500), () {
              flag = true;
            });
            mCenterTipText = "Swipe up to cancel sending";
            mButtonText = "Release to send";
            showAnim = true;
            buildOverLayView(context);
            setState(() {});
            startRecord();
            startY = details.globalPosition.dy;
            mSatrtRecordTime = new DateTime.now().millisecondsSinceEpoch;
          }
        },
        onVerticalDragEnd: (details) {
          setState(() {
            mButtonText = "Hold to record";
          });
          if (offsetY >= 150) {
            print("To cancel recording:" + offsetY.toString());
            cancelRecord();
          } else {
            completeRecord();
          }
        },
        onVerticalDragUpdate: (details) {
          endY = details.globalPosition.dy;
          offsetY = startY - endY;
          print("The offset is:" + "(${offsetY})");
          if (offsetY >= 150) {
            //当手指向上滑，会cancel
            mCenterTipText = "Release your finger to cancel sending";
            voiceIco = "assets/images/ic_volume_cancel.png";
            showAnim = false;
            mOverlayEntry.markNeedsBuild();
            setState(() {
              mButtonText = "Hold to record";
            });
            /*       stopRecording();
                   recordDialog.dismiss();
                   File file = new File(mFile);
                   file.delete();*/
          } else {
            mCenterTipText = "Swipe up to cancel sending";
            mButtonText = "Release to send";
            showAnim = true;
            mOverlayEntry.markNeedsBuild();
          }
        },
        child: Container(
          height: 40,
          decoration: new BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            //设置四周边框
            border: new Border.all(width: 1, color: Color(0xffD2D2D2)),
          ),
          child: SvgPicture.asset("assets/svg/Voice.svg"),
        ),
      ),
    );
  }
}
