import 'package:cyclone/helper/news.dart';
import 'package:cyclone/models/newsModel.dart';
import 'package:cyclone/screens/postViews/ArticleView.dart';
import 'package:cyclone/widgets/CustomPostContainer.dart';
import 'package:cyclone/widgets/customAppbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NewsModel> news = <NewsModel>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    news = newsClass.news;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(),
      body: _isLoading
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
                      onPressed: () {
                        // Navigator.pushNamed(context, '/articleView',
                        //     arguments: ArticleView(
                        //       url: news[index].url,
                        //     ));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ArticleView(
                                      url: news[index].url,
                                    )));
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
