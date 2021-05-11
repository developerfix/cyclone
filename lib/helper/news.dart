import 'dart:convert';

import 'package:cyclone/models/newsModel.dart';
import 'package:cyclone/utils/keys.dart';
import 'package:http/http.dart' as http;

class News {
  List<NewsModel> news = [];

  Future<void> getNews() async {
    String url =
        'https://newsapi.org/v2/everything?q=bitcoin&apiKey=$newsAPIKey';

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);
    try {
      if (jsonData['status'] == 'ok') {
        jsonData['articles'].forEach((element) {
          if (element['urlToImage'] != null &&
              element['description'] != null &&
              element['title'] != null) {
            NewsModel newsModel = NewsModel(
              author: element['author'],
              title: element['title'],
              description: element['description'],
              url: element['url'],
              urlToImage: element['urlToImage'],
              // publishedAt: element['publishedAt'],
              content: element['content'],
            );
            news.add(newsModel);
          }
        });
      }
    } on Exception catch (e) {
      // print(e);
      // print('Empty');
    }
  }
}
