import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_marker.dart';
import 'package:image/image.dart' as images;
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show NetworkAssetBundle, rootBundle;

/// In here we are encapsulating all the logic required to get marker icons from url images
/// and to show clusters using the [Fluster] package.
class MapHelper {
  /// If there is a cached file and it's not old returns the cached marker image file
  /// else it will download the image and save it on the temp dir and return that file.
  ///
  /// This mechanism is possible using the [DefaultCacheManager] package and is useful
  /// to improve load times on the next map loads, the first time will always take more
  /// time to download the file and set the marker image.
  ///
  /// You can resize the marker image by providing a [targetWidth].
  static Future<BitmapDescriptor> getMarkerImageFromUrl(
    String url, {
    int targetWidth,
  }) async {
    final File markerImageFile = await DefaultCacheManager().getSingleFile(url);

    Uint8List markerImageBytes = await markerImageFile.readAsBytes();

    if (targetWidth != null) {
      markerImageBytes = await _resizeImageBytes(
        markerImageBytes,
        targetWidth,
      );
    }

    return BitmapDescriptor.fromBytes(markerImageBytes);
  }

  /// Draw a [clusterColor] circle with the [clusterSize] text inside that is [width] wide.
  ///
  /// Then it will convert the canvas to an image and generate the [BitmapDescriptor]
  /// to be used on the cluster marker icons.
  static Future<BitmapDescriptor> _getClusterMarker(
    int clusterSize,
    Color clusterColor,
    Color textColor,
    int width,
  ) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = clusterColor;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final double radius = width / 2;

    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );

    textPainter.text = TextSpan(
      text: clusterSize.toString(),
      style: TextStyle(
        fontSize: radius - 5,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
    );

    final image = await pictureRecorder.endRecording().toImage(
          radius.toInt() * 2,
          radius.toInt() * 2,
        );
    final data = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  /// Resizes the given [imageBytes] with the [targetWidth].
  ///
  /// We don't want the marker image to be too big so we might need to resize the image.
  static Future<Uint8List> _resizeImageBytes(
    Uint8List imageBytes,
    int targetWidth,
  ) async {
    final Codec imageCodec = await instantiateImageCodec(
      imageBytes,
      targetWidth: targetWidth,
    );

    final FrameInfo frameInfo = await imageCodec.getNextFrame();

    final data = await frameInfo.image.toByteData(format: ImageByteFormat.png);

    return data.buffer.asUint8List();
  }

  static Map<String, MapMarker> _mediaPool;

  /// Inits the cluster manager with all the [MapMarker] to be displayed on the map.
  /// Here we're also setting up the cluster marker itself, also with an [clusterImageUrl].
  ///
  /// For more info about customizing your clustering logic check the [Fluster] constructor.
  static Future<Fluster<MapMarker>> initClusterManager(
    List<MapMarker> markers,
    int minZoom,
    int maxZoom,
  ) async {
    Map<String, MapMarker> _newMap = {};

    markers.forEach((element) {
      _newMap.putIfAbsent(element.childMarkerId, () => element);
    });
    final Map<String, MapMarker> mediaPool =
        Map<String, MapMarker>.from(_newMap);
    _mediaPool = mediaPool;

    return Fluster<MapMarker>(
      minZoom: minZoom,
      maxZoom: maxZoom,
      radius: 150,
      extent: 2048,
      nodeSize: 64,
      points: markers,
      createCluster: (
        BaseCluster cluster,
        double lng,
        double lat,
      ) =>
          MapMarker(
        userName: null,
        position: LatLng(lat, lng),
        isCluster: cluster.isCluster,
        clusterId: cluster.id,
        pointsSize: cluster.pointsSize,
        markerId: cluster.id.toString(),
        childMarkerId: cluster.childMarkerId,
      ),
    );
  }

  /// Gets a list of markers and clusters that reside within the visible bounding box for
  /// the given [currentZoom]. For more info check [Fluster.clusters].
  static Future<List<Marker>> getClusterMarkers(
    Fluster<MapMarker> clusterManager,
    double currentZoom,
    Color clusterColor,
    Color clusterTextColor,
    int clusterWidth,
  ) {
    if (clusterManager == null) return Future.value([]);

    return Future.wait(clusterManager.clusters(
      [-180, -85, 180, 85],
      currentZoom.toInt(),
    ).map((mapMarker) async {
      /*if (mapMarker.isCluster) {
        mapMarker.icon = await _getClusterMarker(
          mapMarker.pointsSize,
          clusterColor,
          clusterTextColor,
          clusterWidth,
        );
      } else {}*/

      if (mapMarker.isCluster) {
        mapMarker.icon = await _createClusterBitmapDescriptor(mapMarker);
        mapMarker.onClusterTap = _getOnTapFromCluster(mapMarker);
        mapMarker.onTap = () {};
        mapMarker.userName = _getUserNameFromCluster(mapMarker);
        mapMarker.thumbnailSrc = _getThumbFromCluster(mapMarker);
      } else {
        print('Markers: ${mapMarker.toJson()}');
        mapMarker.onTap = _getOnTapFromMarker(mapMarker);
      }

      var marker = Marker(
        markerId: MarkerId(mapMarker.markerId),
        position: LatLng(mapMarker.latitude, mapMarker.longitude),
        //infoWindow: InfoWindow(title: mapMarker.userName),
        icon: mapMarker.icon,
        onTap: () {
          print('ALOOOOO');
          if (mapMarker.isCluster) {
            var children = clusterManager.points(mapMarker.clusterId);
            mapMarker.onClusterTap(children);
          } else {
            mapMarker.onTap();
          }
        },
      );
      return marker;
    }).toList());
  }

  static Function(List<MapMarker>) _getOnTapFromCluster(MapMarker feature) {
    MapMarker childMarker = _mediaPool[feature.childMarkerId];
    return childMarker.onClusterTap;
  }

  static String _getUserNameFromCluster(MapMarker feature) {
    MapMarker childMarker = _mediaPool[feature.childMarkerId];
    return childMarker.userName;
  }

  static String _getThumbFromCluster(MapMarker feature) {
    MapMarker childMarker = _mediaPool[feature.childMarkerId];
    return childMarker.thumbnailSrc;
  }

  static Function _getOnTapFromMarker(MapMarker feature) {
    MapMarker childMarker = _mediaPool[feature.childMarkerId];

    return childMarker.onTap;
  }

  static Future<BitmapDescriptor> _createClusterBitmapDescriptor(
      MapMarker feature) async {
    MapMarker childMarker = _mediaPool[feature.childMarkerId];

    var child = await createImage(childMarker.thumbnailSrc, 180, 180);

    if (child == null) {
      return null;
    }

    images.brightness(child, -25);
    child =
        images.copyCropCircle(child, radius: 90, center: images.Point(90, 90));

    var resized = images.copyResize(child, width: 180, height: 180);

    images.drawString(
        resized, images.arial_48, 30, 30, '+${feature.pointsSize}');

    var png = images.encodePng(resized);
    return BitmapDescriptor.fromBytes(png);
  }

  /*static Future<BitmapDescriptor> _createImageBitmapDescriptor(
      String thumbnailSrc) async {
    var resized = await _createImage(thumbnailSrc, 150, 150);

    if (resized == null) {
      return null;
    }

    var png = images.encodePng(resized);

    return BitmapDescriptor.fromBytes(png);
  }*/

  static Future<images.Image> createImage(
      String imageFile, int width, int height) async {
    ByteData imageData;

    try {
      imageData = imageFile != null
          ? await _getBytesFrompath(Uri.parse(imageFile), 150)
          : await _getBytesFromAsset(
              'assets/images/fallbacks/avatar-fallback.jpg', 150);
    } catch (e) {
      print('caught $e');
      return null;
    }

    if (imageData == null) {
      return null;
    }

    List<int> bytes = Uint8List.view(imageData.buffer);
    var image = images.decodeImage(bytes);

    return images.copyResize(image, width: width, height: height);
  }

  static Future<ByteData> _getBytesFrompath(path, width) async {
    var request = await http.get(path);
    var bytes = request.bodyBytes;

    ui.Codec codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asByteData();
  }

  static Future<ByteData> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asByteData();
  }
}
