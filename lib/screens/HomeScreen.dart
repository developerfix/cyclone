import 'dart:convert';

import 'package:cyclone/helper/blogger.dart';
import 'package:cyclone/models/hackerNews/post.dart';
import 'package:cyclone/models/newsModel.dart';
import 'package:cyclone/services/hackerNewsService.dart';
import 'package:cyclone/widgets/newsApi/home_widgets/headline_slider.dart';
import 'package:cyclone/widgets/newsApi/home_widgets/hot_news.dart';
import 'package:cyclone/widgets/newsApi/home_widgets/top_channels.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //HackerNewsArticlesFetching

  List<Story> _stories = <Story>[];

  @override
  void initState() {
    super.initState();
    _populateTopStories();
    getBlogs();
  }

  void _populateTopStories() async {
    final responses = await Webservice().getTopStories();
    final stories = responses.map((response) {
      final json = jsonDecode(response.body);
      return Story.fromJSON(json);
    }).toList();

    setState(() {
      _stories = stories;
    });
  }

  void _navigateToShowCommentsPage(BuildContext context, int index) async {
    final story = this._stories[index];
    final responses = await Webservice().getCommentsByStory(story);
    final comments = responses.map((response) {
      final json = jsonDecode(response.body);
      return Comment.fromJSON(json);
    }).toList();

    debugPrint("$comments");

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             CommentListPage(story: story, comments: comments)));
  }

  // List<NewsModel> blogs = <NewsModel>[];
  List<NewsModel> news = <NewsModel>[];
  bool _isLoading = true;

  getBlogs() async {
    Blogger blogClass = Blogger();
    await blogClass.getBlogs();
    news = blogClass.blogs;
    setState(() {
      if (news.isNotEmpty) {
        _isLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HeadlingSliderWidget(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Text(
                "Top channels",
                style: TextStyle(
                    // color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/sourcesScreen');
                },
                child: Text(
                  "See all",
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
            ],
          ),
        ),
        TopChannelsWidget(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Text(
                "Hot news",
                style: TextStyle(
                    // color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
            ],
          ),
        ),
        HotNewsWidget(),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}
