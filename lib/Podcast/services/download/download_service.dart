import 'package:cyclone/Podcast/entities/episode.dart';
import 'package:cyclone/Podcast/repository/repository.dart';
import 'package:flutter/foundation.dart';

abstract class DownloadService {
  final Repository repository;

  DownloadService({
    @required this.repository,
  });

  Future<bool> downloadEpisode(Episode episode);
  Future<Episode> findEpisodeByTaskId(String taskId);

  void dispose();
}
