import 'package:cyclone/Podcast/entities/episode.dart';
import 'package:cyclone/Podcast/entities/podcast.dart';
import 'package:cyclone/Podcast/state/episode_state.dart';

/// An abstract class that represent the actions supported by the chosen
/// database or storage implementation.
abstract class Repository {
  /// General
  Future<void> close();

  /// Podcasts
  Future<Podcast> findPodcastById(num id);
  Future<Podcast> findPodcastByGuid(String guid);
  Future<Podcast> savePodcast(Podcast podcast);
  Future<void> deletePodcast(Podcast podcast);
  Future<List<Podcast>> subscriptions();

  /// Episodes
  Future<Episode> findEpisodeById(int id);
  Future<Episode> findEpisodeByGuid(String guid);
  Future<List<Episode>> findEpisodesByPodcastGuid(String pguid);
  Future<Episode> findEpisodeByTaskId(String taskId);
  Future<Episode> saveEpisode(Episode episode, [bool updateIfSame]);
  Future<void> deleteEpisode(Episode episode);
  Future<List<Episode>> findDownloadsByPodcastGuid(String pguid);
  Future<List<Episode>> findDownloads();

  /// Event listeners
  Stream<Podcast> podcastListener;
  Stream<EpisodeState> episodeListener;
}
