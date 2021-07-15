import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:cyclone/Podcast/core/environment.dart';
import 'package:cyclone/Podcast/entities/downloadable.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:logging/logging.dart';

import 'download_manager.dart';

/// A [DownloadManager] for handling downloading of podcasts on a mobile device.
class MobileDownloaderManager implements DownloadManager {
  final log = Logger('MobileDownloaderManager');
  final ReceivePort _port = ReceivePort();
  final downloadController = StreamController<DownloadProgress>();

  @override
  Stream<DownloadProgress> get downloadProgress => downloadController.stream;

  MobileDownloaderManager() {
    _init();
  }

  Future _init() async {
    log.fine('Initialising download manager');

    await FlutterDownloader.initialize();
    IsolateNameServer.removePortNameMapping('downloader_send_port');

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');

    var tasks = await FlutterDownloader.loadTasks();

    // Update the status of any tasks that may have been updated whilst
    // AnyTime was close or in the background.
    if (tasks != null && tasks.isNotEmpty) {
      for (var t in tasks) {
        _updateDownloadState(
            id: t.taskId, progress: t.progress, status: t.status);
      }
    }

    _port.listen((dynamic data) {
      final id = data[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      _updateDownloadState(id: id, progress: progress, status: status);
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  Future<String> enqueTask(
      String url, String downloadPath, String fileName) async {
    return await FlutterDownloader.enqueue(
      url: url,
      savedDir: downloadPath,
      fileName: fileName,
      showNotification: true,
      openFileFromNotification: false,
      headers: {'User-Agent': Environment.userAgent()},
    );
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    downloadController.close();
  }

  void _updateDownloadState(
      {String id, int progress, DownloadTaskStatus status}) {
    var state = DownloadState.none;

    if (status == DownloadTaskStatus.enqueued) {
      state = DownloadState.queued;
    } else if (status == DownloadTaskStatus.canceled) {
      state = DownloadState.cancelled;
    } else if (status == DownloadTaskStatus.complete) {
      state = DownloadState.downloaded;
    } else if (status == DownloadTaskStatus.running) {
      state = DownloadState.downloading;
    } else if (status == DownloadTaskStatus.failed) {
      state = DownloadState.failed;
    } else if (status == DownloadTaskStatus.paused) {
      state = DownloadState.paused;
    }

    downloadController.add(DownloadProgress(id, progress, state));
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final send = IsolateNameServer.lookupPortByName('downloader_send_port');

    send.send([id, status, progress]);
  }
}
