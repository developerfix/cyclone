class NewsModel {
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  // DateTime publishedAt;
  String content;

  NewsModel(
      {this.author,
      this.content,
      this.description,
      // this.publishedAt,
      this.title,
      this.url,
      this.urlToImage});
}
