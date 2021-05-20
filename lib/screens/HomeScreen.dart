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
    // getNews();
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

  // YoutubePlayerController _controller = YoutubePlayerController(
  //   initialVideoId: 'D2vUDXFdlzk',
  //   flags: YoutubePlayerFlags(
  //     enableCaption: true,
  //     autoPlay: true,
  //     mute: true,
  //   ),
  // );

  getBlogs() async {
    Blogger blogClass = Blogger();
    await blogClass.getBlogs();
    news = blogClass.blogs;
    setState(() {
      if (news.isNotEmpty) {
        // print(news);
        // print('not empplty');
        _isLoading = false;
      }
    });
  }

  // getNews() async {
  //   News newsClass = News();
  //   await newsClass.getNews();
  //   news = newsClass.news;
  //   setState(() {
  //     if (news.isNotEmpty) {
  //       // print(news);
  //       // print('not empplty');
  //       _isLoading = false;
  //     }
  //     ;
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: ListView.builder(
  //     itemCount: _stories.length,
  //     itemBuilder: (_, index) {
  //       return ListTile(
  //         onTap: () {
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (ctx) => ArticleView(
  //                         url: _stories[index].url,
  //                       )));

  //           // _navigateToShowCommentsPage(context, index);
  //         },
  //         title: Text(_stories[index].title, style: TextStyle(fontSize: 18)),
  //         trailing: Container(
  //             decoration: BoxDecoration(
  //                 color: Colors.green,
  //                 borderRadius: BorderRadius.all(Radius.circular(16))),
  //             alignment: Alignment.center,
  //             width: 50,
  //             height: 50,
  //             child: Padding(
  //               padding: const EdgeInsets.all(12.0),
  //               child: Text("${_stories[index].commentIds.length}",
  //                   style: TextStyle(color: Colors.white)),
  //             )),
  //       );
  //     },
  //   ));
  // }
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    // return
    // YoutubePlayerBuilder(
    //   player: YoutubePlayer(
    //     controller: _controller,
    //   ),
    //   builder: (context, player) {
    return 
    ListView(
      children: [
        HeadlingSliderWidget(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Text(
                "Top channels",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
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
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
            ],
          ),
        ),
        HotNewsWidget()
      ],
    );
    //     Column(
    //   children: [
    //     SizedBox(
    //       height: 100,
    //     ),
    //     player,
    //     SizedBox(
    //       height: 100,
    //     ),
    //   ],
    // )
    // _isLoading
    //     ? Center(
    //         child: Container(
    //           child: CircularProgressIndicator(),
    //         ),
    //       )
    //     : SizedBox(
    //         height: height,
    //         child: ListView.builder(
    //             physics: ClampingScrollPhysics(),
    //             itemCount: news.length,
    //             itemBuilder: (context, index) {
    //               return PostContainer(
    //                 isCustomNewsfeedContainer: false,
    //                 onPressed: () {
    //                   Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (ctx) => ArticleView(
    //                         url: news[index].url,
    //                       ),
    //                     ),
    //                   );
    //                 },
    //                 category: "Article",
    //                 contentPicturePath: news[index].urlToImage,
    //                 publisherPicturePath: "assets/images/health.png",
    //                 title: news[index].author,
    //               );
    //             }),

    // PostContainer(
    //   category: "Blog",
    //   contentPicturePath: 'assets/images/blog.png',
    //   publisherPicturePath: "assets/images/football.png",
    //   title: 'FOOTBALL',
    // ),
    //             ),
    // );
    // }
  }
}
