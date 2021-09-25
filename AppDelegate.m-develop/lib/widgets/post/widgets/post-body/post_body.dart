import 'package:Siuu/models/post.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/widgets/post/widgets/post-body/widgets/post_body_link_preview.dart';
import 'package:Siuu/widgets/post/widgets/post-body/widgets/post_body_media/post_body_media.dart';
import 'package:Siuu/widgets/post/widgets/post-body/widgets/post_body_text.dart';
import 'package:flutter/material.dart';

class OBPostBody extends StatelessWidget {
  final Post post;
  final OnTextExpandedChange onTextExpandedChange;
  final String inViewId;
  final Color shareBoxColor;

  const OBPostBody(
    this.post, {
    Key key,
    this.onTextExpandedChange,
    this.inViewId,
    this.shareBoxColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyItems = [];
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    final double height = MediaQuery.of(context).size.height;
    bodyItems.add(SizedBox(height: height * 0.001));
    if (post.hasText()) {
      if (!post.hasMediaThumbnail() && post.hasLinkToPreview()) {
        bodyItems.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: OBPostBodyLinkPreview(post: post),
          ),
        );
      }

      //print("onTextExpandedChange::$onTextExpandedChange");
      bodyItems.add(OBPostBodyText(
        post,
        onTextExpandedChange: onTextExpandedChange,
      ));
    }
    if (post.hasMediaThumbnail()) {
      bodyItems.add(OBPostBodyMedia(post: post, inViewId: inViewId));
    }
    final bool isShare = post.sharepostData != null;
    return Padding(
      padding: isShare
          ? const EdgeInsets.fromLTRB(10, 0, 10, 0)
          : const EdgeInsets.fromLTRB(5, 5, 5, 0),
      child: Container(
        padding: isShare
            ? const EdgeInsets.fromLTRB(10, 5, 10, 0)
            : const EdgeInsets.fromLTRB(5, 5, 5, 0),
        decoration: isShare
            ? BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: shareBoxColor,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  right: BorderSide(
                    color: shareBoxColor,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  bottom: BorderSide(
                    color: shareBoxColor,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: bodyItems,
        ),
      ),
    );
  }
}
