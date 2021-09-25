import 'package:Siuu/models/post_comment.dart';
import 'package:Siuu/pages/home/pages/post_comments/post_comments_page_controller.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/theme.dart';
import 'package:Siuu/services/theme_value_parser.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';

class MemoryCommentsHeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    ThemeService _themeService = provider.themeService;
    LocalizationService _localizationService = provider.localizationService;
    ThemeValueParserService _themeValueParserService =
        provider.themeValueParserService;
    var theme = _themeService.getActiveTheme();
    Map<String, String> _pageTextMap;

    _pageTextMap = this.getPageCommentsMap(_localizationService);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: OBSecondaryText(
                _pageTextMap['BE_THE_FIRST'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
            ),
          ),
          Expanded(
            child: FlatButton(
                child: OBText(
                  '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: _themeValueParserService
                          .parseGradient(theme.primaryAccentColor)
                          .colors[1],
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  //
                }),
          ),
        ],
      ),
    );
  }

  Map<String, String> getPageCommentsMap(
      LocalizationService _localizationService) {
    return {
      'NEWEST': _localizationService.post__comments_header_newest_comments,
      'NEWER': _localizationService.post__comments_header_newer,
      'VIEW_NEWEST':
          _localizationService.post__comments_header_view_newest_comments,
      'SEE_NEWEST':
          _localizationService.post__comments_header_see_newest_comments,
      'OLDEST': _localizationService.post__comments_header_oldest_comments,
      'OLDER': _localizationService.post__comments_header_older,
      'VIEW_OLDEST':
          _localizationService.post__comments_header_view_oldest_comments,
      'SEE_OLDEST':
          _localizationService.post__comments_header_see_oldest_comments,
      'BE_THE_FIRST':
          _localizationService.post__comments_header_be_the_first_comments,
    };
  }

  Map<String, String> getPageRepliesMap(
      LocalizationService _localizationService) {
    return {
      'NEWEST': _localizationService.post__comments_header_newest_replies,
      'NEWER': _localizationService.post__comments_header_newer,
      'VIEW_NEWEST':
          _localizationService.post__comments_header_view_newest_replies,
      'SEE_NEWEST':
          _localizationService.post__comments_header_see_newest_replies,
      'OLDEST': _localizationService.post__comments_header_oldest_replies,
      'OLDER': _localizationService.post__comments_header_older,
      'VIEW_OLDEST':
          _localizationService.post__comments_header_view_oldest_replies,
      'SEE_OLDEST':
          _localizationService.post__comments_header_see_oldest_replies,
      'BE_THE_FIRST':
          _localizationService.post__comments_header_be_the_first_replies,
    };
  }
}
