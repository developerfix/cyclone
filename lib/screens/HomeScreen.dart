import 'package:cyclone/helper/blogger.dart';
import 'package:cyclone/helper/news.dart';
import 'package:cyclone/models/newsModel.dart';
import 'package:cyclone/screens/postViews/ArticleView.dart';
import 'package:cyclone/widgets/CustomPostContainer.dart';
import 'package:cyclone/widgets/customAppbar.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  void initState() {
    super.initState();
    // getNews();
    getBlogs();
  }

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
      ;
    });
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    news = newsClass.news;
    setState(() {
      if (news.isNotEmpty) {
        // print(news);
        // print('not empplty');
        _isLoading = false;
      }
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    // return
    // YoutubePlayerBuilder(
    //   player: YoutubePlayer(
    //     controller: _controller,
    //   ),
    //   builder: (context, player) {
    return Scaffold(
      body:
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
          _isLoading
              ? Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SizedBox(
                  height: height,
                  child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      itemCount: news.length,
                      itemBuilder: (context, index) {
                        return PostContainer(
                          isCustomNewsfeedContainer: false,
                          onPressed: () {
                            // Navigator.pushNamed(context, '/articleView',
                            //     arguments: ArticleView(
                            //       url: news[index].url,
                            //     ));
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (ctx) => ArticleView(
                            //               url: news[index].url,
                            //             )));
                          },
                          category: "Article",
                          contentPicturePath: news[index].urlToImage,
                          publisherPicturePath: "assets/images/health.png",
                          title: news[index].author,
                        );
                      }),

                  // PostContainer(
                  //   category: "Blog",
                  //   contentPicturePath: 'assets/images/blog.png',
                  //   publisherPicturePath: "assets/images/football.png",
                  //   title: 'FOOTBALL',
                  // ),
                ),
    );
  }
}
