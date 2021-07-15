import 'package:cyclone/Podcast/bloc/bloc.dart';
import 'package:cyclone/Podcast/bloc/discovery/discovery_state_event.dart';
import 'package:cyclone/Podcast/services/podcast/podcast_service.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:podcast_search/podcast_search.dart' as pcast;
import 'package:rxdart/rxdart.dart';

/// A BLoC to interact with the Discovery UI page and the [PodcastService] to
/// fetch the iTunes charts. As charts will not change very frequently the
/// results are cached for [cacheMinutes].
class DiscoveryBloc extends Bloc {
  static const cacheMinutes = 30;
  final log = Logger('DiscoveryBloc');
  final PodcastService podcastService;

  final BehaviorSubject<DiscoveryEvent> _discoveryInput =
      BehaviorSubject<DiscoveryEvent>();

  Stream<DiscoveryState> _discoveryResults;
  pcast.SearchResult _resultsCache;

  DiscoveryBloc({@required this.podcastService}) {
    _init();
  }

  void _init() {
    _discoveryResults = _discoveryInput
        .switchMap<DiscoveryState>((DiscoveryEvent event) => _charts(event));
  }

  Stream<DiscoveryState> _charts(DiscoveryEvent event) async* {
    yield DiscoveryLoadingState();

    if (event is DiscoveryChartEvent) {
      if (_resultsCache == null ||
          DateTime.now().difference(_resultsCache.processedTime).inMinutes >
              cacheMinutes) {
        _resultsCache = await podcastService.charts(size: event.count);
      }

      yield DiscoveryPopulatedState<pcast.SearchResult>(_resultsCache);
    }
  }

  @override
  void dispose() {
    _discoveryInput.close();
  }

  void Function(DiscoveryEvent) get discover => _discoveryInput.add;
  Stream<DiscoveryState> get results => _discoveryResults;
}
