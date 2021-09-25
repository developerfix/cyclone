import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/theme.dart';
import 'package:Siuu/services/theme_value_parser.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/buttons/floating_action_button.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/new_post_data_uploader.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

class OBMemoryNewPostButton extends StatelessWidget {
  final bool isDisabled;
  final bool isLoading;
  final Color textColor;
  final OBButtonSize size;
  final double minWidth;
  final EdgeInsets padding;
  final OBButtonType type;
  final Memory crew;
  final ValueChanged<OBNewPostData> onWantsToUploadNewPostData;

  const OBMemoryNewPostButton({
    this.type = OBButtonType.primary,
    this.size = OBButtonSize.medium,
    this.textColor = Colors.white,
    this.isDisabled = false,
    this.isLoading = false,
    this.padding,
    this.minWidth,
    this.crew,
    this.onWantsToUploadNewPostData,
  });

  Widget build(BuildContext context) {
    LocalizationService _localizationService =
        OpenbookProvider.of(context).localizationService;
    return StreamBuilder(
      stream: crew.updateSubject,
      initialData: crew,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        Memory crew = snapshot.data;

        String crewHexColor = crew.color;
        OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
        ThemeValueParserService themeValueParserService =
            openbookProvider.themeValueParserService;
        ThemeService themeService = openbookProvider.themeService;

        OBTheme currentTheme = themeService.getActiveTheme();
        Color currentThemePrimaryColor =
            themeValueParserService.parseColor(currentTheme.primaryColor);
        double currentThemePrimaryColorLuminance =
            currentThemePrimaryColor.computeLuminance();

        Color crewColor = themeValueParserService.parseColor(crewHexColor);
        Color textColor = themeValueParserService.isDarkColor(crewColor)
            ? Colors.white
            : Colors.black;
        double crewColorLuminance = crewColor.computeLuminance();

        if (crewColorLuminance > 0.9 &&
            currentThemePrimaryColorLuminance > 0.9) {
          // Is extremely white and our current theem is also extremely white, darken it
          crewColor = TinyColor(crewColor).darken(5).color;
        } else if (crewColorLuminance < 0.1) {
          // Is extremely dark and our current theme is also extremely dark, lighten it
          crewColor = TinyColor(crewColor).lighten(10).color;
        }

        return Semantics(
            button: true,
            label: _localizationService.post__create_new_community_post_label,
            child: OBFloatingActionButton(
                color: crewColor,
                textColor: textColor,
                onPressed: () async {

                  print("yessssssss clickkkkkkk");

                  OpenbookProviderState openbookProvider =
                      OpenbookProvider.of(context);
                  OBNewPostData createPostData = await openbookProvider
                      .modalService
                      .openCreatePost(context: context, crew: crew);
                  if (createPostData != null &&
                      onWantsToUploadNewPostData != null)
                    onWantsToUploadNewPostData(createPostData);
                },
                child: OBIcon(OBIcons.createPost,
                    size: OBIconSize.large, color: textColor)));
      },
    );
  }
}
