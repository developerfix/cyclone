import 'package:cyclone/Podcast/entities/podcast.dart';
import 'package:cyclone/Podcast/l10n/L.dart';
import 'package:cyclone/Podcast/ui/widgets/podcast_tile.dart';
import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart' as search;

class PodcastList extends StatelessWidget {
  const PodcastList({
    Key key,
    @required this.results,
  }) : super(key: key);

  final search.SearchResult results;

  @override
  Widget build(BuildContext context) {
    if (results.items.isNotEmpty) {
      return SliverList(
          delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final i = results.items[index];
          final p = Podcast.fromSearchResultItem(i);

          return PodcastTile(podcast: p);
        },
        childCount: results.items.length,
        addAutomaticKeepAlives: false,
      ));
    } else {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.search,
                size: 75,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                L.of(context).noSearchResultsMessage,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
}
