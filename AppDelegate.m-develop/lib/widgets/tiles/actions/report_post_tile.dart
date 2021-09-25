import 'package:Siuu/models/post.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:Siuu/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';

class OBReportPostTile extends StatefulWidget {
  final Post post;
  final ValueChanged<Post> onPostReported;
  final VoidCallback onWantsToReportPost;

  const OBReportPostTile({
    Key key,
    this.onPostReported,
    @required this.post,
    this.onWantsToReportPost,
  }) : super(key: key);

  @override
  OBReportPostTileState createState() {
    return OBReportPostTileState();
  }
}

class OBReportPostTileState extends State<OBReportPostTile> {
  NavigationService _navigationService;
  LocalizationService _localizationService;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _navigationService = openbookProvider.navigationService;
    _localizationService = openbookProvider.localizationService;

    return StreamBuilder(
      stream: widget.post.updateSubject,
      initialData: widget.post,
      builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
        var post = snapshot.data;

        bool isReported = post.isReported ?? false;

        return OBLoadingTile(
          isLoading: _requestInProgress || isReported,
          leading: OBIcon(OBIcons.report),
          title: OBText(
              isReported ? _localizationService.moderation__you_have_reported_post_text : _localizationService.moderation__report_post_text),
          onTap: isReported ? () {} : _reportPost,
        );
      },
    );
  }

  void _reportPost() {
    if (widget.onWantsToReportPost != null) widget.onWantsToReportPost();
    _navigationService.navigateToReportObject(
        context: context,
        object: widget.post,
        onObjectReported: (dynamic reportedObject) {
          if (reportedObject != null && widget.onPostReported != null)
            widget.onPostReported(reportedObject as Post);
        });
  }
}
