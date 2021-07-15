import 'package:cyclone/Podcast/bloc/discovery/discovery_state_event.dart';
import 'package:cyclone/Podcast/l10n/L.dart';
import 'package:cyclone/Podcast/state/bloc_state.dart';
import 'package:cyclone/Podcast/ui/widgets/platform_progress_indicator.dart';
import 'package:cyclone/Podcast/ui/widgets/podcast_list.dart';
import 'package:cyclone/Podcast/ui/widgets/podcast_list_with_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart' as search;

class DiscoveryResults extends StatelessWidget {
  final Stream<DiscoveryState> data;
  final bool inlineSearch;

  DiscoveryResults({@required this.data, this.inlineSearch});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DiscoveryState>(
      stream: data,
      builder: (BuildContext context, AsyncSnapshot<DiscoveryState> snapshot) {
        final state = snapshot.data;

        if (state is DiscoveryPopulatedState) {
          if (inlineSearch)
            return PodcastListWithSearchBar(
                results: state.results as search.SearchResult);
          return PodcastList(results: state.results as search.SearchResult);
        } else {
          if (state is DiscoveryLoadingState) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  PlatformProgressIndicator(),
                ],
              ),
            );
          } else if (state is BlocErrorState) {
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

          return SliverFillRemaining(
            hasScrollBody: false,
            child: Container(),
          );
        }
      },
    );
  }
}
