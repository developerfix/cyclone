import 'package:Siuu/models/post.dart';
import 'dart:developer';


class PostsList {
  final List<Post> posts;

  PostsList({
    this.posts,
  });

  factory PostsList.fromJson(List<dynamic> parsedJson) {


    log("parsed json::$parsedJson");

    List<Post> posts = parsedJson.map((postJson) => Post.fromJson(postJson)).toList();

    return new PostsList(
      posts: posts,
    );
  }
}
