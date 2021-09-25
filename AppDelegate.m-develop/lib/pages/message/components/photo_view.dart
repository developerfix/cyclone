import 'dart:developer';
import 'dart:io';

import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/consts/massage_consts.dart';
import 'package:Siuu/models/message_model.dart';
import 'package:Siuu/pages/message/components/custom_progress.dart';
import 'package:Siuu/utils/firestore_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryItem {
  final String path;
  final bool isLocal;
  final Timestamp timestamp;

  GalleryItem({this.path, this.timestamp, this.isLocal});
}

class PhotoViewer extends StatefulWidget {
  final String path;
  final List<Message> messages;
  final String userId;

  const PhotoViewer({
    this.path,
    this.messages,
    this.userId,
  });
  @override
  _PhotoViewerState createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  PageController controller;
  List<GalleryItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.vertical,
      key: const Key('key'),
      onDismissed: (_) => Navigator.of(context).pop(),
      child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (_, int index) {
          return PhotoViewGalleryPageOptions(
              imageProvider: items[index].isLocal
                  ? FileImage(File(items[index].path))
                  : CachedNetworkImageProvider(items[index].path),
              initialScale: PhotoViewComputedScale.contained,
              minScale: PhotoViewComputedScale.contained * 0.2);
        },
        itemCount: items.length,
        reverse: true,
        loadingBuilder: (context, event) =>
            Center(child: CustomCircularIndicator()),
        pageController: controller,
        onPageChanged: (int index) {
          if (index == items.length - 5) {
            fethMoreImages();
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    List<Message> images = widget.messages;

    for (var i = 0; i < images.length; i++) {
      items.add(GalleryItem(
          path: images[i].imageUrl ?? images[i].temporaryImagePath,
          isLocal: images[i].imageUrl == null,
          timestamp: images[i].timestamp));
    }
    log('${items.length}');

    int initial = items.indexWhere((m) => m.path == widget.path);

    controller = PageController(
      initialPage: images.isEmpty ? 0 : initial,
    );
    if (initial >= items.length - 5) {
      fethMoreImages();
    }
  }

  bool canLoad = true;
  void fethMoreImages() {
    log('load more');
    if (!canLoad) return;
    firestore
        .collection(specificMessagesPath(widget.userId))
        .limit(10)
        .orderBy('timestamp', descending: true)
        .where('type', isEqualTo: Message_Image_Type)
        .startAfter([items.last.timestamp])
        .get()
        .then((snapshot) {
          log('${snapshot.docs.length}');
          if (snapshot.docs.isEmpty) {
            canLoad = false;
            return;
          }

          List<Message> images = [];
          for (var i = 0; i < snapshot.docs.length; i++) {
            Message _m = Message.fromMap(snapshot.docs[i].data());
            if (_m.imageUrl != null || _m.temporaryImagePath != null)
              images.add(_m);
          }
          for (var i = 0; i < images.length; i++) {
            items.add(GalleryItem(
                path: images[i].imageUrl ?? images[i].temporaryImagePath,
                isLocal: images[i].imageUrl == null,
                timestamp: images[i].timestamp));
          }
          setState(() {
            log('${items.length}');
          });
        });
  }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }
}
