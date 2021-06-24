import 'package:cyclone/Podcast/entities/episode.dart';

abstract class EpisodeState {
  final Episode episode;

  EpisodeState(this.episode);
}

class EpisodeUpdateState extends EpisodeState {
  EpisodeUpdateState(Episode episode) : super(episode);
}

class EpisodeDeleteState extends EpisodeState {
  EpisodeDeleteState(Episode episode) : super(episode);
}
