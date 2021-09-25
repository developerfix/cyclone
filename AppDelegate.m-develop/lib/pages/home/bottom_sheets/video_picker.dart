import 'dart:io';
import 'package:Siuu/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/media/media.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class OBVideoPickerBottomSheet extends StatelessWidget {
  const OBVideoPickerBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);

    LocalizationService localizationService = provider.localizationService;

    List<Widget> videoPickerActions = [
      ListTile(
        leading: const OBIcon(OBIcons.gallery),
        title: OBText(
          localizationService.video_picker__from_gallery,
        ),
        onTap: () async {
          bool permissionGranted = await provider.permissionService
              .requestStoragePermissions(context: context);
          if (permissionGranted) {
            FilePickerResult result =
                await FilePicker.platform.pickFiles(type: FileType.video);
            File file = File(result.files.single.path);
            Navigator.pop(context, file);
          }
        },
      ),
      ListTile(
        leading: const OBIcon(OBIcons.camera),
        title: OBText(
          localizationService.video_picker__from_camera,
        ),
        onTap: () async {
          bool permissionGranted = await provider.permissionService
              .requestCameraPermissions(context: context);
          if (permissionGranted) {
            var video =
                await ImagePicker().getVideo(source: ImageSource.camera);
            File pickedVideo = File(video.path);
            Navigator.pop(context, pickedVideo);
          }
        },
      )
    ];

    return OBRoundedBottomSheet(
        child: Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        children: videoPickerActions,
        mainAxisSize: MainAxisSize.min,
      ),
    ));
  }
}