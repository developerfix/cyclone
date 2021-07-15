import 'package:cyclone/Podcast/api/podcast/podcast_api.dart';
import 'package:cyclone/Podcast/core/environment.dart';
import 'package:flutter/foundation.dart';
import 'package:podcast_search/podcast_search.dart';

/// An implementation of the PodcastApi. A simple wrapper class that
/// interacts with the iTunes/Podcastindex search API via the
/// podcast_search package.
class MobilePodcastApi extends PodcastApi {
  final Search api = Search();

  @override
  Future<SearchResult> search(
    String term, {
    String country,
    String attribute,
    int limit,
    String language,
    int version = 0,
    bool explicit = false,
    String searchProvider,
  }) async {
    var searchParams = {
      'term': term,
      'searchProvider': searchProvider,
    };

    return compute(_search, searchParams);
  }

  @override
  Future<SearchResult> charts(
    int size,
  ) async {
    return compute(_charts, 0);
  }

  @override
  Future<Podcast> loadFeed(String url) async {
    return _loadFeed(url);
  }

  @override
  Future<Chapters> loadChapters(String url) async {
    return Podcast.loadChaptersByUrl(url: url);
  }

  static Future<SearchResult> _search(Map<String, String> searchParams) {
    var term = searchParams['term'];
    var provider = searchParams['searchProvider'] == 'itunes'
        ? ITunesProvider()
        : PodcastIndexProvider(
            key: podcastIndexKey,
            secret: podcastIndexSecret,
          );

    return Search(userAgent: Environment.userAgent())
        .search(
          term,
          searchProvider: provider,
        )
        .timeout(Duration(seconds: 30));
  }

  static Future<SearchResult> _charts(int size) {
    return Search(userAgent: Environment.userAgent())
        .charts()
        .timeout(Duration(seconds: 30));
  }

  static Future<Podcast> _loadFeed(String url) {
    return Podcast.loadFeed(url: url, userAgent: Environment.userAgent());
  }
}
