import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/posts_stream/posts_stream.dart';
import 'package:Siuu/widgets/theming/highlighted_box.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';

class OBPostsStreamDrHoo extends StatelessWidget {
  final VoidCallback streamRefresher;
  final OBPostsStreamStatus streamStatus;
  final List<Widget> streamPrependedItems;

  const OBPostsStreamDrHoo({
    Key key,
    @required this.streamRefresher,
    @required this.streamStatus,
    @required this.streamPrependedItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String drHooTitle;
    String drHooSubtitle;
    String drHooImage = 'assets/images/404.png';
    bool hasRefreshButton = false;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    LocalizationService localizationService =
        openbookProvider.localizationService;

    switch (streamStatus) {
      case OBPostsStreamStatus.refreshing:
        drHooTitle = localizationService.posts_stream__refreshing_drhoo_title;
        drHooSubtitle =
            localizationService.posts_stream__refreshing_drhoo_subtitle;
        break;
      case OBPostsStreamStatus.noMoreToLoad:
        drHooTitle = localizationService.posts_stream__empty_drhoo_title;
        drHooSubtitle = localizationService.posts_stream__empty_drhoo_subtitle;
        break;
      case OBPostsStreamStatus.loadingMoreFailed:
        drHooImage = 'assets/images/404.png';
        drHooTitle =
            localizationService.post__timeline_posts_failed_drhoo_title;
        drHooSubtitle =
            localizationService.post__timeline_posts_failed_drhoo_subtitle;
        hasRefreshButton = true;
        break;
      case OBPostsStreamStatus.empty:
        drHooImage = 'assets/images/404.png';
        drHooTitle = localizationService.posts_stream__empty_drhoo_title;
        drHooSubtitle = localizationService.posts_stream__empty_drhoo_subtitle;
        hasRefreshButton = true;
        break;
      default:
        drHooTitle =
            localizationService.post__timeline_posts_default_drhoo_title;
        drHooSubtitle =
            localizationService.post__timeline_posts_default_drhoo_subtitle;
        hasRefreshButton = true;
    }

    List<Widget> drHooColumnItems = [
      Image.asset(
        drHooImage,
      ),
      const SizedBox(
        height: 20.0,
      ),
      /*OBText(
        drHooTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
        textAlign: TextAlign.center,
      ),*/
      const SizedBox(
        height: 10.0,
      ),
      OBText(
        drHooSubtitle,
        textAlign: TextAlign.center,
      )
    ];

    if (hasRefreshButton) {
      drHooColumnItems.addAll([
        const SizedBox(
          height: 30,
        ),
        OBButton(
          icon: const OBIcon(
            OBIcons.refresh,
            size: OBIconSize.large,
          ),
          type: OBButtonType.highlight,
          child: Container(),
          onPressed: streamRefresher,
          isLoading: streamStatus == OBPostsStreamStatus.refreshing,
        )
      ]);
    }

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical:
              streamPrependedItems != null && streamPrependedItems.isNotEmpty ||
                      streamStatus == OBPostsStreamStatus.empty ||
                      streamStatus == OBPostsStreamStatus.refreshing ||
                      streamStatus == OBPostsStreamStatus.loadingMoreFailed
                  ? 20
                  : 0),
      child: OBHighlightedBox(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        borderRadius: BorderRadius.circular(10),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: drHooColumnItems,
            ),
          ),
        ),
      ),
    );
  }
}
