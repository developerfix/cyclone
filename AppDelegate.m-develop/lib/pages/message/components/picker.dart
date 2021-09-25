import 'dart:convert';
import 'dart:io';
import 'package:Siuu/pages/home/pages/memories/categories.dart';
import 'package:Siuu/pages/home/widgets/FlutterCoustomCamera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

enum ImageType { Camera, Gallery }

class Picker {
  Future<String> pickImageType(ImageType op, BuildContext context) async {
    String _image;
    if (op == ImageType.Camera) {
      _image = await pickFromAppCamera(context);
    } else if (op == ImageType.Gallery) {
      PickedFile file =
          await ImagePicker().getImage(source: ImageSource.gallery);
      _image = file.path;
    }

    return _image;
  }

  Future<String> pickFromAppCamera(BuildContext context) async {
    String path;
    CameraDescriptionList = await availableCameras();
    coustom_camera_controller = CameraController(
      CameraDescriptionList[0],
      ResolutionPreset.high,
      enableAudio: true,
    );
    try {
      await coustom_camera_controller.initialize();

      final File result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FlutterCoustomCamera(storyType: StoryType.Picture),
        ),
      );

      print(result);
      if (result != null) {
        if ((result.path.endsWith(".jpg") ||
            result.path.endsWith(".png") ||
            result.path.endsWith(".gif"))) {
          path = result.path;
        }
      }
    } on CameraException catch (e) {
      // _showCameraException(e);
    }
    return path;
  }

  Future<String> pickLottie(BuildContext context) async {
    if (lotties == null || lotties.isEmpty) return null;
    String res = await showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18))),
      builder: (cnt) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
          child: GridView.builder(
            itemCount: lotties.length,
            itemBuilder: (_, pos) {
              if (lotties[pos] == null || lotties[pos] == '')
                return Container();
              return InkWell(
                onTap: () {
                  Navigator.pop(cnt, lotties[pos]);
                },
                child: Lottie.asset(
                  lotties[pos],
                ),
              );
            },
            padding: EdgeInsets.only(top: 16, bottom: 16),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          ),
        ),
      ),
    );
    return res;
  }
}

List<String> lotties;

fetchLotties(BuildContext context) async {
  final manifestContent =
      await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

  // Decode to Map
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  // Filter by path
  lotties = manifestMap.keys
      .where((path) => path.startsWith('assets/sorted_lotties/'))
      .toList();
  lotties.sort((a, b) {
    return a.toLowerCase().compareTo(b.toLowerCase());
  });
}
