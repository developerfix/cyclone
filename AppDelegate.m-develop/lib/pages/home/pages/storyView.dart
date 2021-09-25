import 'package:Siuu/story/controller/story_controller.dart';
import 'package:Siuu/story/story_view.dart';
import 'package:Siuu/story/widgets/story_video.dart';
import 'package:flutter/material.dart';
import 'package:Siuu/models/UserStory.dart';
import 'package:Siuu/pages/home/pages/FixedStoryView.dart';

class StoryViewWidget extends StatelessWidget {
  final StoryController controller;
  StoryViewWidget(
    this.controller,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(
          8,
        ),
        child: ListView(
          children: <Widget>[
            /*     Container(
              height: 300,
              child: StoryView(
                controller: controller,
                storyItems: [
                  StoryItem.text(
                    title:
                        "Hello world!\nHave a look at some great Ghanaian delicacies. I'm sorry if your mouth waters. \n\nTap!",
                    backgroundColor: Colors.orange,
                    roundedTop: true,
                  ),
                  // StoryItem.inlineImage(
                  //   NetworkImage(
                  //       "https://image.ibb.co/gCZFbx/Banku-and-tilapia.jpg"),
                  //   caption: Text(
                  //     "Banku & Tilapia. The food to keep you charged whole day.\n#1 Local food.",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       backgroundColor: Colors.black54,
                  //       fontSize: 17,
                  //     ),
                  //   ),
                  // ),
                  StoryItem.inlineImage(
                    url:
                        "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
                    controller: controller,
                    caption: Text(
                      "Omotuo & Nkatekwan; You will love this meal if taken as supper.",
                      style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.black54,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  StoryItem.inlineImage(
                    url:
                        "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
                    controller: controller,
                    caption: Text(
                      "Hektas, sektas and skatad",
                      style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.black54,
                        fontSize: 17,
                      ),
                    ),
                  )
                ],
                onStoryShow: (s) {
                  print("Showing a story");
                },
                onComplete: () {
                  print("Completed a cycle");
                },
                progressPosition: ProgressPosition.bottom,
                repeat: false,
                inline: true,
              ),
            ),*/
            Material(
              child: InkWell(
                onTap: () {
                  /*      Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MoreStories()));*/
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(8))),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "View more stories",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoreStories extends StatefulWidget {
  final StoryController storyController;
  final FocusNode textFocus;
  List<Story> userStory;
  final ValueChanged<String> currentStory;
  final ValueChanged<StoryItem> currentStoryItem;
  final double width, height;

  MoreStories({
    this.storyController,
    this.textFocus,
    this.userStory,
    @required this.currentStory,
    @required this.currentStoryItem,
    this.width,
    this.height,
  }); //MoreStories(this.userStory);

  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  List<StoryItem> storyItems;

  @override
  void initState() {
    //ADDED FOR AVOIDING RE-CREATE NEED TO CREATE IT ONCE
    storyItems = storyItem();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FixedStoryView(
      textFocus: widget.textFocus,
      storyItems: storyItems,
      onStoryShow: (s) {
        widget.currentStory(s.id.toString());
        if (widget.currentStoryItem != null) widget.currentStoryItem(s);
      },
      onComplete: () {
        Navigator.pop(context);
      },
      repeat: false,
      progressPosition: ProgressPosition.top,
      controller: widget.storyController,
      onVerticalSwipeComplete: (Direction direction) {
        print('Vertical Swipe Completed $direction');
        if (direction == Direction.down) {
          Navigator.pop(context);
        }
      },
    );
  }

  List<StoryItem> storyItem() {
    var userStoryitem = widget.userStory;
    var controller = widget.storyController;
    List<StoryItem> storyItem = new List();

    for (int i = 0; i < userStoryitem.length; i++) {
      if (userStoryitem[i].type == "text") {
        storyItem.add(StoryItem.text(
          background: userStoryitem[i].background,
          id: userStoryitem[i].id,
          title: userStoryitem[i].text != null ? userStoryitem[i].text : "",
          textStyle: TextStyle(
            fontFamily: userStoryitem[i].font,
            fontSize: 40,
          ),
          width: widget.width,
          height: widget.height,
        ));
      }
      if (userStoryitem[i].type == "image") {
        storyItem.add(StoryItem.pageImage(
            url: "http://62.171.176.52:80" + userStoryitem[i].image.toString(),
            id: userStoryitem[i].id,
            caption: "",
            controller: controller));
      }

      if (userStoryitem[i].type == "video") {
        print("story url::" + userStoryitem[i].video.toString());
        storyItem.add(StoryItem.pageVideo(
            "http://62.171.176.52:80" + userStoryitem[i].video.toString(),
            id: userStoryitem[i].id,
            caption: "",
            controller: controller,
            shown: true,
            duration: Duration(seconds: 24)));
      }
    }

    return storyItem;
  }

/*  List<StoryItem> storyItem() {
    List<StoryItem> storyItem = [];
    storyItem.add(StoryItem.pageImage(
        url:
        "https://cdn.pixabay.com/photo/2014/02/27/16/10/tree-276014__340.jpg",
        caption: "",
        controller: widget.storyController));
    storyItem.add(StoryItem.pageImage(
        url:
        "https://i.pinimg.com/736x/50/df/34/50df34b9e93f30269853b96b09c37e3b.jpg",
        caption: "",
        controller: widget.storyController));
    storyItem.add(StoryItem.pageImage(
        url:
        "https://i.pinimg.com/originals/cb/16/bb/cb16bb284a2a80c75041c80ba63e62d3.jpg",
        caption: "",
        controller: widget.storyController));

    return storyItem;
  }*/
}
