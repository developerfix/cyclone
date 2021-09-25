class UrlData {
  final String site_name;
  final String url;
  final String image;
  final String title;
  final String description;

  UrlData(this.url, this.site_name, this.image, this.title, this.description);

  String get name =>
      "${site_name == null ? '' : '$site_name - '}${title ?? ''}";

  factory UrlData.fromMap(Map<String, dynamic> map) {
    return UrlData(
      map['url'],
      map['og:site_name'],
      map['og:image'],
      map['og:title'],
      map['og:description'],
    );
  }

  @override
  String toString() {
    return 'UrlData(site_name: $site_name, url: $url, image: $image, title: $title, description: $description)';
  }
}
