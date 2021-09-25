import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// [Fluster] can only handle markers that conform to the [Clusterable] abstract class.
///
/// You can customize this class by adding more parameters that might be needed for
/// your use case. For instance, you can pass an onTap callback or add an
/// [InfoWindow] to your marker here, then you can use the [toMarker] method to convert
/// this to a proper [Marker] that the [GoogleMap] can read.
class MapMarker extends Clusterable {
  final LatLng position;
  BitmapDescriptor icon;
  String userName;
  String thumbnailSrc;
  Function onTap;
  Function(List<MapMarker>) onClusterTap;
  DateTime time;
  int storyCount = 1;

  MapMarker({
    @required this.userName,
    @required this.position,
    this.thumbnailSrc,
    this.icon,
    isCluster = false,
    String markerId,
    clusterId,
    pointsSize,
    String childMarkerId,
    this.onTap,
    this.onClusterTap,
    this.time,
  }) : super(
          markerId: markerId,
          latitude: position.latitude,
          longitude: position.longitude,
          isCluster: isCluster,
          clusterId: clusterId,
          pointsSize: pointsSize,
          childMarkerId: childMarkerId,
        );

  /*Marker toMarker() => Marker(
        markerId: MarkerId(isCluster ? 'cl_$markerId' : markerId),
        position: LatLng(
          position.latitude,
          position.longitude,
        ),
        icon: icon ?? BitmapDescriptor.defaultMarker,
      );*/
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'position': position,
      'thumbnailSrc': thumbnailSrc,
      'icon': icon,
      'isCluster': isCluster,
      'markerId': markerId,
      'pointsSize': pointsSize,
      'clusterId': clusterId,
      'childMarkerId': childMarkerId,
      'onTap': onTap,
      'onClusterTap': onClusterTap,
      'time': time,
    };
  }
}

class MarkerWithFunctions {
  Marker marker;
  Function onTap;
  String userName;
  String avatar;
  Function(List<MapMarker>) onClusterTap;
  DateTime time;
  MarkerWithFunctions({
    @required this.marker,
    this.onTap,
    this.userName,
    this.avatar,
    this.onClusterTap,
    this.time,
  });
}
