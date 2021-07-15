import 'dart:convert';

import 'package:cyclone/models/newsModel.dart';
import 'package:cyclone/utils/keys.dart';
import 'package:http/http.dart' as http;

class Blogger {
  List<NewsModel> blogs = [];

  Future<void> getBlogs() async {
    String url =
        'https://www.googleapis.com/blogger/v3/blogs/2399953?key=$bloggerAPIKey';

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        print('jsonData Status: ');
        print(response.statusCode);

        //  jsonData['urlToImage'] != null &&
        //         jsonData['description'] != null &&
        //         jsonData['title'] != null) {
        NewsModel newsModel = NewsModel(
          author: jsonData['name'],
          title: jsonData['title'],
          description: jsonData['description'],
          url: jsonData['url'] != null
              ? 'http://blogger.googleblog.com/'
              : jsonData['url'],
          urlToImage:
              'https://images.unsplash.com/photo-1619454949033-8d2f1c9783b2?ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzfHx8ZW58MHx8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          // publishedAt: element['publishedAt'],
          content: null,
        );
        blogs.add(newsModel);
      } else {
        print('failed');
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
