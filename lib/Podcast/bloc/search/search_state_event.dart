/// Events
class SearchEvent {}

class SearchTermEvent extends SearchEvent {
  final String term;

  SearchTermEvent(this.term);
}

class SearchChartsEvent extends SearchEvent {}

class SearchClearEvent extends SearchEvent {}

/// States
class SearchState {}

class SearchLoadingState extends SearchState {}
