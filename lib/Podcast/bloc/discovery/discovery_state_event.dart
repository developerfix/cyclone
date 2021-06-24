import 'package:flutter/foundation.dart';

/// Events
class DiscoveryEvent {}

class DiscoveryChartEvent extends DiscoveryEvent {
  final int count;

  DiscoveryChartEvent({@required this.count});
}

/// States
class DiscoveryState {}

class DiscoveryLoadingState extends DiscoveryState {}

class DiscoveryPopulatedState<T> extends DiscoveryState {
  final T results;

  DiscoveryPopulatedState(this.results);
}
