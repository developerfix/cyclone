import 'dart:io';

import 'package:Siuu/models/UserStory.dart';
import 'package:Siuu/pages/home/pages/camera.dart';
import 'package:Siuu/pages/home/pages/memories/TextMemory.dart';
import 'package:Siuu/pages/home/pages/memories/VoiceMemory.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/linear_progress_indicator.dart';
import 'package:Siuu/widgets/tiles/loading_indicator_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:Siuu/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Siuu/pages/home/widgets/FlutterCoustomCamera.dart';
import 'package:flutter_better_camera/camera.dart';

import 'package:Siuu/services/toast.dart';

import 'videoMemory.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  VideoPlayerController _videoPlayerController;
  TextEditingController _textController;
  Position _currentPosition;
  String _currentAddress;

  File _video;
  File _image;
  String backgroudnameselected = "";
  UserService _userService;
  ToastService _toastService;

  final picker = ImagePicker();
  StoryType type = StoryType.Text;
  bool value;
  BuildContext _context;

  ValueNotifier<Widget> stickyWidget;
  FocusNode focusOfKeyboard;
  ValueNotifier<TextStyle> currentFont;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();

    stickyWidget = ValueNotifier(Container());
    currentFont = ValueNotifier(null);
    focusOfKeyboard = FocusNode();

    _image = null;
    value = false;
  }

  _pickVideo() async {
    PickedFile pickedFile = await picker.getVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(seconds: 30),
    );
    _video = File(pickedFile.path);

    print("final Vedio ::${pickedFile.path}");

    _videoPlayerController = VideoPlayerController.file(_video)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }

  _pickImage() async {
    PickedFile pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );
    setState(() {});
    _image = File(pickedFile.path);
    print("this is image path::${_image.path}");
  }

  void shareStory() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () async {
                          final UserStory myStory =
                              await _uploadStoryWithGettingLocation();
                          Navigator.pop(
                            context,
                            {
                              'page': 'categories',
                              'story': myStory,
                            },
                          );
                          //_getCurrentLocation();
                        },
                        child: Text(
                          "With Map",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: const Color(0xff7F00FF),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () async {
                          final UserStory myStory = await uploadStory();
                          print(myStory);
                          Navigator.pop(
                            context,
                            {
                              'page': 'categories',
                              'story': myStory,
                            },
                          );
                        },
                        child: Text(
                          "With my followers",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xff7F00FF),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<UserStory> uploadStory() async {
    if (_textController.text.isEmpty && _image == null && _video == null) {
      _toastService.error(
          message: "Write something before to post", context: _context);
      return UserStory(
        myStories: [],
        stories: [],
      );
    }

    if (type == StoryType.Text) {
      return await _userService.uploadStory(
        _toastService,
        background: backgroudnameselected,
        text: _textController.text,
        type: "text",
        vedio: null,
        image: null,
        context: _context,
        font: currentFont.value.fontFamily,
      );
    } else if (type == StoryType.Picture) {
      return await _userService.uploadStory(
        _toastService,
        background: backgroudnameselected,
        context: _context,
        text: _textController.text,
        type: "image",
        vedio: null,
        image: _image,
        font: currentFont.value.fontFamily,
      );
    } else if (type == StoryType.Video) {
      return await _userService.uploadStory(
        _toastService,
        background: backgroudnameselected,
        text: _textController.text,
        context: _context,
        type: "video",
        vedio: _video,
        image: null,
        font: currentFont.value.fontFamily,
      );
    }
    return UserStory(
      myStories: [],
      stories: [],
    );
  }

  Future<UserStory> uploadWithMap(Position positionOfUser) async {
    if (_textController.text.isEmpty && _image == null && _video == null) {
      _toastService.error(
          message: "Write something before to post", context: _context);

      return UserStory(
        myStories: [],
        stories: [],
      );
    }

    if (type == StoryType.Text) {
      return await _userService.uploadStoryWithMap(
        _toastService,
        background: backgroudnameselected,
        text: _textController.text,
        context: _context,
        type: "text",
        vedio: null,
        image: null,
        lat: positionOfUser.latitude,
        long: positionOfUser.longitude,
        avatar: _userService.getLoggedInUser().profile.avatar,
        font: currentFont.value.fontFamily,
      );
    } else if (type == StoryType.Picture) {
      return await _userService.uploadStoryWithMap(
        _toastService,
        text: _textController.text,
        context: _context,
        type: "image",
        vedio: null,
        background: backgroudnameselected,
        image: _image,
        lat: positionOfUser.latitude,
        long: positionOfUser.longitude,
        avatar: _userService.getLoggedInUser().profile.avatar,
        font: currentFont.value.fontFamily,
      );
    } else if (type == StoryType.Video) {
      return await _userService.uploadStoryWithMap(
        _toastService,
        text: _textController.text,
        context: _context,
        type: "video",
        vedio: _video,
        image: null,
        background: backgroudnameselected,
        lat: positionOfUser.latitude,
        long: positionOfUser.longitude,
        avatar: _userService.getLoggedInUser().profile.avatar,
        font: currentFont.value.fontFamily,
      );
    }

    return UserStory(
      myStories: [],
      stories: [],
    );
  }

  Future<UserStory> _uploadStoryWithGettingLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    return await uploadWithMap(_currentPosition);
  }

  void addCameraDiscription() async {
    CameraDescriptionList = await availableCameras();
    //if(cameras!=null){
    /*    for (CameraDescription cameraDescription in cameras) {
        CameraDescriptionList.add(cameraDescription);}*/

    coustom_camera_controller = CameraController(
      CameraDescriptionList[0],
      ResolutionPreset.high,
      enableAudio: true,
    );

    try {
      await coustom_camera_controller.initialize();
      _navigateAndDisplaySelection(context, type);
    } on CameraException catch (e) {
      // _showCameraException(e);
    }

    //}
    //  else{print("cameras is empty");}
  }

  Future _navigateAndDisplaySelection(
      BuildContext context, StoryType storyType) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlutterCoustomCamera(
          storyType: storyType,
        ),
      ),
    );

    print(result);
    if (result != null) {
      File _file = result as File;

      if ((_file.path.endsWith(".jpg") ||
              _file.path.endsWith(".png") ||
              _file.path.endsWith(".gif")) ||
          storyType == StoryType.Picture) {
        setState(() {
          print('succeed');
          _image = _file;
        });
        //_setPostImageFile(_file);
      } else {
        _video = result;
        _videoPlayerController = VideoPlayerController.file(_video)
          ..initialize().then((_) {
            print('succeed 2');
            setState(() {});
            _videoPlayerController.play();
          });

        //_setPostVideoFile(_file);
      }
    } else {
      setState(() {
        type = StoryType.Text;
      });
    }
  }

  _getAddressFromLatLng() async {
    try {
      /* List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });*/
    } catch (e) {
      print(e);
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _image = null;
  // }

  // fixme abubakar story issue
  @override
  Widget build(BuildContext context) {
    _context = context;

    var provider = OpenbookProvider.of(context);
    _toastService = provider.toastService;
    _userService = provider.userService;

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    Widget widgetType;

    switch (type) {
      case StoryType.Text:
        widgetType = //Container();
            TextMemory(
          controller: _textController,
          onBackgroudSelect: (backgroudname) {
            backgroudnameselected = backgroudname;
          },
          focusNode: focusOfKeyboard,
          stickyWidget: stickyWidget,
          currentFont: currentFont,
        );
        break;
      case StoryType.Picture:
        widgetType = imageMemory();
        break;
      case StoryType.Voice:
        widgetType = VoiceMemory();
        break;
      case StoryType.Video:
        widgetType = videoMemory();
        break;
      default:
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Container(
            width: 60,
            height: 60,
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 25,
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xff7F00FF),
                    Color(0xffE100FF),
                  ],
                )),
          ),
          onPressed: () {
            if (_textController.text.isEmpty &&
                _image == null &&
                _video == null) {
              _toastService.error(
                  message: "Write something before to post", context: _context);
              return;
            }

            shareStory();
          },
        ),
        bottomSheet: ValueListenableBuilder<Widget>(
          valueListenable: stickyWidget,
          builder: (context, newStickyWidget, child) {
            return newStickyWidget;
          },
        ),
        body: SingleChildScrollView(
          child: Wrap(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                height: height * 0.192 - 30,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          type = StoryType.Text;
                        });
                      },
                      child: buildSizedBox(
                        text: 'Text',
                        icon: Icons.format_color_text,
                        color: [
                          Color(0xff1a2a6c),
                          Color(0xffb21f1f),
                          Color(0xfffdbb2d),
                          // Color(0xff03001e),
                          // Color(0xff7303c0),
                          // Color(0xffec38bc),
                          // Color(0xfffdeff9),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width * 0.024,
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          addCameraDiscription();
                          type = StoryType.Picture;
                        });
                      },
                      child: buildSizedBox(
                        text: 'Pictures',
                        icon: Icons.photo_sharp,
                        color: [
                          Color(0xffc0392b),
                          Color(0xff8e44ad),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width * 0.024,
                    ),
                    /*InkWell(
                        onTap: () {
                          setState(() {
                            type = StoryType.Voice;
                          });
                        },
                        child: buildSizedBox(
                            text: 'VoiceClips',
                            icon: Icons.record_voice_over,
                            color: [
                              Color(0xff7F00FF),
                              Color(0xffE100FF),
                            ]),
                      ),*/
                    SizedBox(
                      width: width * 0.004,
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          addCameraDiscription();
                          type = StoryType.Video;
                        });
                      },
                      child: buildSizedBox(
                        text: 'Videos',
                        icon: Icons.videocam_sharp,
                        color: [
                          Color(0xffFDC830),
                          Color(0xffF37335),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.024,
              ),
              widgetType != null
                  ? Container(
                      child: widgetType,
                    )
                  : Column(
                      children: [
                        Text(
                          'Record live story with\ncamera here',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Segoe UI",
                              fontSize: 18,
                              color: Colors.blueGrey),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              size: 40,
                            ),
                            onPressed: null)
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget videoMemory() {
    return _video == null
        ? Center(
            child: OBLoadingIndicatorTile(),
          )
        : _video != null
            ? _videoPlayerController.value.initialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  )
                : Container()
            : Container();

    return InkWell(
      onTap: () async {
        await _pickVideo();
      },
      child: _video == null
          ? Column(
              children: [
                Text(
                  'Record live story with\ncamera here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 18,
                      color: Colors.blueGrey),
                ),
                IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      size: 40,
                    ),
                    onPressed: null)
              ],
            )
          : VideoMemory(
              video: _video != null
                  ? _videoPlayerController.value.initialized
                      ? AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController),
                        )
                      : Container()
                  : Container(),
            ),
    );
  }

  Widget imageMemory() {
    return _image == null
        ? Center(
            child: OBLoadingIndicatorTile(),
          )
        : Container(
            child: Image.file(File(_image.path)),
          );
    return InkWell(
      onTap: () async {
        await _pickImage();
      },
      child: _image == null
          ? Column(
              children: [
                Text(
                  'Take a picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 18,
                      color: Colors.blueGrey),
                ),
                IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      size: 40,
                    ),
                    onPressed: null)
              ],
            )
          : Container(
              child: Image.asset(_image.path),
            ),
    );
  }

  SizedBox buildSizedBox({String text, List<Color> color, IconData icon}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.292,
      width: width * 0.364,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(
              height: height * 0.014,
            ),
            Text(
              text,
              style: TextStyle(
                  fontFamily: "Segoe UI",
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

enum StoryType { Text, Picture, Voice, Video }
