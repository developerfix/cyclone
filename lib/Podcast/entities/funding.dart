/// A class that represents and individual funding option that may be
/// part of a [Podcast].
///
/// Part of the [podcast namespace](https://github.com/Podcastindex-org/podcast-namespace)
class Funding {
  /// The URL to the funding/donation/information page.
  final String url;

  /// The label for the link which will be presented to the user.
  final String value;

  const Funding({
    this.url,
    this.value,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'value': value,
    };
  }

  static Funding fromMap(Map<String, dynamic> chapter) {
    return Funding(
      url: chapter['url'] as String,
      value: chapter['value'] as String,
    );
  }
}
