import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/hashtag.dart';
import 'package:Siuu/models/moderation/moderation_category.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/post_comment.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/alerts/alert.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/fields/text_form_field.dart';
import 'package:Siuu/widgets/markdown.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBConfirmReportObject extends StatefulWidget {
  final dynamic object;
  final Map<String, dynamic> extraData;
  final ModerationCategory category;

  const OBConfirmReportObject(
      {Key key, @required this.object, @required this.category, this.extraData})
      : super(key: key);

  @override
  OBConfirmReportObjectState createState() {
    return OBConfirmReportObjectState();
  }
}

class OBConfirmReportObjectState extends State<OBConfirmReportObject> {
  bool _confirmationInProgress;
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;
  bool _needsBootstrap;
  TextEditingController _descriptionController;

  String description;

  CancelableOperation _submitReportOperation;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _confirmationInProgress = false;
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    if (_submitReportOperation != null) _submitReportOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _localizationService = openbookProvider.localizationService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(
            title: _localizationService.moderation__confirm_report_title),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    OBText(
                      _localizationService
                          .moderation__confirm_report_provide_details,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OBSecondaryText(
                      _localizationService
                          .moderation__confirm_report_provide_optional_info,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OBAlert(
                      padding: const EdgeInsets.all(10),
                      child: OBTextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        hasBorder: false,
                        decoration: InputDecoration(
                          hintText: _localizationService
                              .moderation__confirm_report_provide_optional_hint_text,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    OBText(
                      _localizationService
                          .moderation__confirm_report_provide_happen_next,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OBMarkdown(
                        onlyBody: true,
                        data: _localizationService
                            .moderation__confirm_report_provide_happen_next_desc)
                  ],
                ),
              ),
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OBButton(
                      size: OBButtonSize.large,
                      child: Text(_localizationService
                          .moderation__confirm_report_submit),
                      onPressed: _onConfirm,
                      isLoading: _confirmationInProgress,
                    ),
                  )
                ],
              ),
            )
          ],
        )));
  }

  void _onConfirm() async {
    _setConfirmationInProgress(true);
    try {
      if (widget.object is Post) {
        _submitReportOperation = CancelableOperation.fromFuture(
            _userService.reportPost(
                description: _descriptionController.text,
                post: widget.object,
                moderationCategory: widget.category));
      } else if (widget.object is PostComment) {
        _submitReportOperation = CancelableOperation.fromFuture(
            _userService.reportPostComment(
                description: _descriptionController.text,
                post: widget.extraData['post'],
                postComment: widget.object,
                moderationCategory: widget.category));
      } else if (widget.object is Memory) {
        _submitReportOperation = CancelableOperation.fromFuture(
            _userService.reportMemory(
                description: _descriptionController.text,
                crew: widget.object,
                moderationCategory: widget.category));
      } else if (widget.object is User) {
        _submitReportOperation = CancelableOperation.fromFuture(
            _userService.reportUser(
                description: _descriptionController.text,
                user: widget.object,
                moderationCategory: widget.category));
      } else if (widget.object is Hashtag) {
        _submitReportOperation = CancelableOperation.fromFuture(
            _userService.reportHashtag(
                description: _descriptionController.text,
                hashtag: widget.object,
                moderationCategory: widget.category));
      } else {
        throw 'Object type not supported';
      }
      await _submitReportOperation.value;
      if (widget.object is User ||
          widget.object is Memory ||
          widget.object is Post ||
          widget.object is PostComment ||
          widget.object is Hashtag) {
        widget.object.setIsReported(true);
      }
      _toastService.success(
          message: _getSuccessMessageForObject(widget.object),
          context: context);
      Navigator.of(context).pop(true);
    } catch (error) {
      _onError(error);
    } finally {
      _setConfirmationInProgress(false);
    }
  }

  String _getSuccessMessageForObject(dynamic modelInstance) {
    String result;
    if (modelInstance is Post) {
      result = _localizationService.moderation__confirm_report_post_reported;
    } else if (modelInstance is PostComment) {
      result =
          _localizationService.moderation__confirm_report_post_comment_reported;
    } else if (modelInstance is Memory) {
      result =
          _localizationService.moderation__confirm_report_community_reported;
    } else if (modelInstance is User) {
      result = _localizationService.moderation__confirm_report_user_reported;
    } else {
      result = _localizationService.moderation__confirm_report_item_reported;
    }
    return result;
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _setConfirmationInProgress(confirmationInProgress) {
    setState(() {
      _confirmationInProgress = confirmationInProgress;
    });
  }
}