import 'dart:async';

import 'package:cyclone/Podcast/entities/downloadable.dart';

class DownloadProgress {
  final String id;
  final int percentage;
  final DownloadState status;

  DownloadProgress(
    this.id,
    this.percentage,
    this.status,
  );
}

abstract class DownloadManager {
  Future<String> enqueTask(String url, String downloadPath, String fileName);
  Stream<DownloadProgress> get downloadProgress;
  void dispose();
}
