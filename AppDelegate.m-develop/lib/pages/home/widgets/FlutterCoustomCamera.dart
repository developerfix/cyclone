// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:Siuu/pages/home/pages/memories/categories.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:Siuu/services/media/media.dart';
import 'package:Siuu/provider.dart';

class FlutterCoustomCamera extends StatefulWidget {
  final StoryType storyType;
  const FlutterCoustomCamera({
    @required this.storyType,
  });
  @override
  _FlutterCoustomCameraState createState() {
    return _FlutterCoustomCameraState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  return Icons.flip_camera_ios;

  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _FlutterCoustomCameraState extends State<FlutterCoustomCamera>
    with WidgetsBindingObserver {
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;
  FlashMode flashMode = FlashMode.off;
  CameraDescription _cameraDescription;
  bool isbackCamera = true;
  Color buttonColor = Colors.transparent;
  MediaService _mediaService;

  @override
  void initState() {
    super.initState();
    _cameraDescription = new CameraDescription();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (coustom_camera_controller == null ||
        !coustom_camera_controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      coustom_camera_controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (coustom_camera_controller != null) {
        onNewCameraSelected(coustom_camera_controller.description);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);

    _mediaService = openbookProvider.mediaService;

    final hight = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                color: Colors.red,
                child: ZoomableWidget(
                  child: _cameraPreviewWidget(),
                  onTapUp: (scaledPoint) {
                    coustom_camera_controller.setPointOfInterest(scaledPoint);
                  },
                  onZoom: (zoom) {
                    print('zoom');
                    if (zoom < 11) {
                      coustom_camera_controller.zoom(zoom);
                    }
                  },
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _flashButton(),
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  topLeft: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                ),
                                border: Border.all(
                                  width: 3,
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Center(
                                  child: GestureDetector(
                                onTap: () {
                                  onTakePictureButtonPressed();
                                },
                                onLongPress: () {
                                  setState(() {
                                    buttonColor = Colors.red;
                                  });
                                  onVideoRecordButtonPressed();
                                },
                                onLongPressUp: () {
                                  setState(() {
                                    buttonColor = Colors.transparent;
                                  });
                                  onStopButtonPressed();
                                  //: null;
                                },
                              )),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (isbackCamera) {
                                  isbackCamera = false;
                                  setState(() {
                                    onNewCameraSelected(
                                        CameraDescriptionList[1]);
                                  });
                                } else {
                                  isbackCamera = true;
                                  setState(() {
                                    onNewCameraSelected(
                                        CameraDescriptionList[0]);
                                  });
                                }
                              },
                              child: Container(
                                height: 80,
                                width: 80,
                                child: Icon(
                                  Icons.flip_camera_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: () async {
                            _unfocusTextField();
                            try {
                              var pickedMedia;
                              if (widget.storyType == StoryType.Picture) {
                                pickedMedia =
                                    await _mediaService.pickMediaFromGallery(
                                  context: context,
                                  source: ImageSource.gallery,
                                  flattenGifs: false,
                                  fileType: FileType.image,
                                );
                              } else if (widget.storyType == StoryType.Video) {
                                pickedMedia =
                                    await _mediaService.pickMediaFromGallery(
                                  context: context,
                                  source: ImageSource.gallery,
                                  flattenGifs: false,
                                  fileType: FileType.video,
                                );
                              } else if (widget.storyType == StoryType.Voice) {
                                pickedMedia =
                                    await _mediaService.pickMediaFromGallery(
                                  context: context,
                                  source: ImageSource.gallery,
                                  flattenGifs: false,
                                  fileType: FileType.audio,
                                );
                              } else {
                                pickedMedia = await _mediaService.pickMedia(
                                  context: context,
                                  source: ImageSource.gallery,
                                  flattenGifs: false,
                                );
                              }
                              Navigator.pop(context, pickedMedia.file);
                              /*    if (pickedMedia != null) {
                                    if (pickedMedia.type == FileType.image) {
                                      _setPostImageFile(pickedMedia.file);
                                    } else {
                                      _setPostVideoFile(pickedMedia.file);
                                    }
                                  }*/
                            } catch (error) {
                              //_onError(error);
                            }
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            child: Icon(
                              Icons.perm_media_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 80,
                  width: 80,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            )

            /* _cameraTogglesRowWidgetold(),
            _toggleAudioWidget(),
            Padding (
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _cameraTogglesRowWidget(),
                  _thumbnailWidget(),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  void _unfocusTextField() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    /* if (CameraDescriptionList.length > 0) {
      if (controller == null || !controller.value.isInitialized) {
        onNewCameraSelected(CameraDescriptionList[0]);
      }
    }*/

    print("this is coustom camera::$coustom_camera_controller");

    if (coustom_camera_controller == null ||
        !coustom_camera_controller.value.isInitialized) {
      return const Text(
        '',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      final size = MediaQuery.of(context).size.width;
      return CameraPreview(coustom_camera_controller);
    }
  }

  /// Toggle recording audio
  Widget _toggleAudioWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Row(
        children: <Widget>[
          const Text('Enable Audio:'),
          Switch(
            value: enableAudio,
            onChanged: (bool value) {
              enableAudio = value;
              if (coustom_camera_controller != null) {
                onNewCameraSelected(coustom_camera_controller.description);
              }
            },
          ),
        ],
      ),
    );
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            videoController == null && imagePath == null
                ? Container()
                : SizedBox(
                    child: (videoController == null)
                        ? Image.file(File(imagePath))
                        : Container(
                            child: Center(
                              child: AspectRatio(
                                  aspectRatio:
                                      videoController.value.size != null
                                          ? videoController.value.aspectRatio
                                          : 1.0,
                                  child: VideoPlayer(videoController)),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.pink)),
                          ),
                    width: 64.0,
                    height: 64.0,
                  ),
          ],
        ),
      ),
    );
  }

  // Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: coustom_camera_controller != null &&
                  coustom_camera_controller.value.isInitialized &&
                  !coustom_camera_controller.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: coustom_camera_controller != null &&
                  coustom_camera_controller.value.isInitialized &&
                  !coustom_camera_controller.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: coustom_camera_controller != null &&
                  coustom_camera_controller.value.isRecordingPaused
              ? Icon(Icons.play_arrow)
              : Icon(Icons.pause),
          color: Colors.blue,
          onPressed: coustom_camera_controller != null &&
                  coustom_camera_controller.value.isInitialized &&
                  coustom_camera_controller.value.isRecordingVideo
              ? (coustom_camera_controller != null &&
                      coustom_camera_controller.value.isRecordingPaused
                  ? onResumeButtonPressed
                  : onPauseButtonPressed)
              : null,
        ),
        IconButton(
          icon: coustom_camera_controller != null &&
                  coustom_camera_controller.value.autoFocusEnabled
              ? Icon(Icons.access_alarm)
              : Icon(Icons.access_alarms),
          color: Colors.blue,
          onPressed: (coustom_camera_controller != null &&
                  coustom_camera_controller.value.isInitialized)
              ? toogleAutoFocus
              : null,
        ),
        _flashButton(),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: coustom_camera_controller != null &&
                  coustom_camera_controller.value.isInitialized &&
                  coustom_camera_controller.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        ),
      ],
    );
  }

  /// Flash Toggle Button
  Widget _flashButton() {
    IconData iconData = Icons.flash_off;
    Color color = Colors.white;
    if (flashMode == FlashMode.alwaysFlash) {
      iconData = Icons.flash_on;
      color = Colors.white;
    } else if (flashMode == FlashMode.autoFlash) {
      iconData = Icons.flash_auto;
      color = Colors.white;
    }
    return Container(
      height: 80,
      width: 80,
      child: IconButton(
        icon: Icon(iconData),
        color: color,
        onPressed: coustom_camera_controller != null &&
                coustom_camera_controller.value.isInitialized
            ? _onFlashButtonPressed
            : null,
      ),
    );
  }

  /// Toggle Flash
  Future<void> _onFlashButtonPressed() async {
    bool hasFlash = false;
    if (flashMode == FlashMode.off || flashMode == FlashMode.torch) {
      // Turn on the flash for capture
      flashMode = FlashMode.alwaysFlash;
    } else if (flashMode == FlashMode.alwaysFlash) {
      // Turn on the flash for capture if needed
      flashMode = FlashMode.autoFlash;
    } else {
      // Turn off the flash
      flashMode = FlashMode.off;
    }
    // Apply the new mode
    await coustom_camera_controller.setFlashMode(flashMode);

    // Change UI State
    setState(() {});
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    if (cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      onNewCameraSelected(CameraDescriptionList[0]);

      return SizedBox(
        width: 90.0,
        child: GestureDetector(
          onTap: () {
            if (isbackCamera) {
              isbackCamera = false;
              setState(() {
                onNewCameraSelected(CameraDescriptionList[1]);
              });
            } else {
              isbackCamera = true;
              setState(() {
                onNewCameraSelected(CameraDescriptionList[0]);
              });
            }
          },
          child: Container(
            child: Icon(Icons.flip_camera_ios),
          ),
        ),

        /*RadioListTile<CameraDescription>(
              title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
              groupValue: controller?.description,
              value: cameraDescription,
              onChanged: controller != null && controller.value.isRecordingVideo ? null : onNewCameraSelected,)*/
      );
    }
  }

  Widget _cameraTogglesRowWidgetold() {
    final List<Widget> toggles = <Widget>[];

    if (cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      for (CameraDescription cameraDescription in cameras) {
        CameraDescriptionList.add(cameraDescription);

        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
              groupValue: coustom_camera_controller?.description,
              value: cameraDescription,
              onChanged: coustom_camera_controller != null &&
                      coustom_camera_controller.value.isRecordingVideo
                  ? null
                  : onNewCameraSelected,
            ),
          ),
        );
      }
    }

    // return Row(children: toggles);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (coustom_camera_controller != null) {
      await coustom_camera_controller.dispose();
    }
    print("controller:111:$cameraDescription");

    coustom_camera_controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: enableAudio,
    );

    // If the controller is updated then update the UI.
    coustom_camera_controller.addListener(() {
      if (mounted) setState(() {});
      if (coustom_camera_controller.value.hasError) {
        showInSnackBar(
            'Camera error ${coustom_camera_controller.value.errorDescription}');
      }
    });

    try {
      await coustom_camera_controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          videoController?.dispose();
          videoController = null;
        });
        if (filePath != null) {
          //showInSnackBar('Picture saved to $filePath');}

          Navigator.pop(context, File(imagePath));
        }
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      print("fileepath::$filePath");
      if (mounted) setState(() {});
      // if (filePath != null) showInSnackBar('Saving video to $filePath');
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      // showInSnackBar('Video recorded to: $videoPath');
      Navigator.pop(context, File(videoPath));
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      // showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      // showInSnackBar('Video recording resumed');
    });
  }

  void toogleAutoFocus() {
    coustom_camera_controller
        .setAutoFocus(!coustom_camera_controller.value.autoFocusEnabled);
    showInSnackBar('Toogle auto focus');
  }

  Future<String> startVideoRecording() async {
    if (!coustom_camera_controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (coustom_camera_controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      asyncTimeController();
      await coustom_camera_controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  final int timeLimit = 15;
  int _time;
  String recordKey;
  asyncTimeController() async {
    final myKey = UniqueKey().toString();
    recordKey = myKey;
    _time = 0;
    while (_time < timeLimit && recordKey == myKey) {
      await Future.delayed(Duration(seconds: 1));
      if (recordKey == myKey) _time += 1;
    }
    if (recordKey == myKey) {
      showInSnackBar('Video cannot be longer than $timeLimit seconds');
      onStopButtonPressed();
    }
  }

  Future<void> stopVideoRecording() async {
    if (!coustom_camera_controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await coustom_camera_controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    showInSnackBar(videoPath);

    //  await _startVideoPlayer();
  }

  Future<void> pauseVideoRecording() async {
    if (!coustom_camera_controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await coustom_camera_controller.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!coustom_camera_controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await coustom_camera_controller.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  Future<String> takePicture() async {
    if (!coustom_camera_controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (coustom_camera_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await coustom_camera_controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

List<CameraDescription> cameras = [];
List<CameraDescription> CameraDescriptionList = new List();
CameraController coustom_camera_controller;

void addCameraDiscription() async {
  cameras = await availableCameras();
  if (cameras != null) {
    for (CameraDescription cameraDescription in cameras) {
      CameraDescriptionList.add(cameraDescription);
    }
  } else {
    print("cameras is empty");
  }
}

Future<void> flutterCameraApp() async {
  print("callll");
  // addCameraDiscription();

  // Fetch the available cameras before initializing the app.
  try {
    print("callll::;intry");

    WidgetsFlutterBinding.ensureInitialized();
  } on CameraException catch (e) {
    print("callll::;catch");

    logError(e.code, e.description);
  }
  // runApp(CameraApp());
}

//Zoomer this will be a seprate widget
class ZoomableWidget extends StatefulWidget {
  final Widget child;
  final Function onZoom;
  final Function onTapUp;

  const ZoomableWidget({Key key, this.child, this.onZoom, this.onTapUp})
      : super(key: key);

  @override
  _ZoomableWidgetState createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget> {
  Matrix4 matrix = Matrix4.identity();
  double zoom = 1;
  double prevZoom = 1;
  bool showZoom = false;
  Timer t1;

  bool handleZoom(newZoom) {
    if (newZoom >= 1) {
      if (newZoom > 10) {
        return false;
      }
      setState(() {
        showZoom = true;
        zoom = newZoom;
      });

      if (t1 != null) {
        t1.cancel();
      }

      t1 = Timer(Duration(milliseconds: 2000), () {
        setState(() {
          showZoom = false;
        });
      });
    }
    widget.onZoom(zoom);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onScaleStart: (scaleDetails) {
          print('scalStart');
          setState(() => prevZoom = zoom);
          //print(scaleDetails);
        },
        onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
          var newZoom = (prevZoom * scaleDetails.scale);

          handleZoom(newZoom);
        },
        onScaleEnd: (scaleDetails) {
          print('end');
          //print(scaleDetails);
        },
        onTapUp: (TapUpDetails det) {
          final RenderBox box = context.findRenderObject();
          final Offset localPoint = box.globalToLocal(det.globalPosition);
          final Offset scaledPoint =
              localPoint.scale(1 / box.size.width, 1 / box.size.height);
          // TODO IMPLIMENT
          // widget.onTapUp(scaledPoint);
        },
        child: Stack(children: [
          Positioned.fill(child: widget.child),
          Visibility(
            visible: showZoom, //Default is true,
            child: Positioned.fill(
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        valueIndicatorTextStyle: TextStyle(
                            color: Colors.amber,
                            letterSpacing: 2.0,
                            fontSize: 30),
                        valueIndicatorColor: Colors.blue,
                        // This is what you are asking for
                        inactiveTrackColor: Color(0xFF8D8E98),
                        // Custom Gray Color
                        activeTrackColor: Colors.white,
                        thumbColor: Colors.red,
                        overlayColor: Color(0x29EB1555),
                        // Custom Thumb overlay Color
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 20.0),
                      ),
                      child: Slider(
                        value: zoom,
                        onChanged: (double newValue) {
                          handleZoom(newValue);
                        },
                        label: "$zoom",
                        min: 1,
                        max: 10,
                      ),
                    ),
                  ),
                ],
              )),
            ),
            //maintainSize: bool. When true this is equivalent to invisible;
            //replacement: Widget. Defaults to Sizedbox.shrink, 0x0
          )
        ]));
  }
}
