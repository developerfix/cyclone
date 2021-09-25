import 'package:Siuu/models/UserStory.dart';
import 'package:Siuu/models/moment_comment.dart';
import 'package:Siuu/models/moment_comment_list.dart';
import 'package:Siuu/pages/home/lib/draft_editing_controller.dart';
import 'package:Siuu/pages/home/pages/memories/memory_comments/widgets/memory_commenter.dart';
import 'package:Siuu/pages/home/pages/memories/memory_comments/widgets/memory_comments_header_bar.dart';
import 'package:Siuu/pages/home/pages/memories/memory_comments/widgets/memory_preview.dart';
import 'package:Siuu/pages/home/pages/memories/memory_comments/widgets/post_comment/memory_comment.dart';
import 'package:Siuu/pages/home/pages/post_comments/post_comments_page_controller.dart';
import 'package:Siuu/pages/home/pages/post_comments/widgets/post_comments_header_bar.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/draft.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/story/story_view.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/theming/post_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MemoryCommentPage extends StatefulWidget {
  final Story story;
  final StoryItem storyItem;

  const MemoryCommentPage({
    @required this.story,
    @required this.storyItem,
  });

  @override
  _MemoryCommentPageState createState() => _MemoryCommentPageState();
}

class _MemoryCommentPageState extends State<MemoryCommentPage> {
  TextEditingController textController;
  MomentCommentList momentCommentList;
  UserService userService;
  Future<MomentCommentList> futureMomentCommentList;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var provider = OpenbookProvider.of(context);
    userService = provider.userService;
    if (futureMomentCommentList == null) {
      futureMomentCommentList =
          userService.getCommentsForMoment(widget.story.id);
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      appBar: OBThemedNavigationBar(
        title: 'Moment Comments',
      ),
      resizeToAvoidBottomInset: true,
      bottomSheet: Container(
        width: width,
        color: Colors.white,
        child: MemoryCommenter(
          widget.story,
          textController: textController,
          onMomentCommentCreated: (MomentComment comment) {
            setState(() {
              momentCommentList?.commentCount += 1;
              momentCommentList?.comments?.insert(0, comment);
            });
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.white,
        ),
        width: width,
        height: height,
        child: builder(),
      ),
    );
  }

  Widget builder() {
    return ListView(
      children: <Widget>[
        _getPostPreview(),
        _getDivider(),
        MemoryCommentsHeaderBar(),
        chatList(),
        SizedBox(
          height: 100,
        ),
      ],
    );
  }

  Widget chatList() {
    return FutureBuilder<MomentCommentList>(
      future: futureMomentCommentList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (momentCommentList == null) momentCommentList = snapshot.data;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: momentCommentList?.comments?.length ?? 0,
            itemBuilder: (context, index) {
              return MemoryComment(
                story: widget.story,
                momentComment: momentCommentList.comments[index],
                onMomentCommentDeleted: (deletedMoment) {
                  userService.deleteStoryComment(
                      storyId: deletedMoment.story,
                      commentId: deletedMoment.id);
                  setState(() {
                    momentCommentList.comments.removeWhere(
                        (element) => element.id == deletedMoment.id);
                  });
                },
              );
            },
          );
        } else {
          return Center(
            child: Container(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _getPostPreview() {
    return MemoryPreview(story: widget.story, storyItem: widget.storyItem);
  }

  Widget _getDivider() {
    return OBPostDivider();
  }
}
