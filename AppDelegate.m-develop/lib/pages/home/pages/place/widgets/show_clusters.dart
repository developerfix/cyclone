import 'package:Siuu/models/UserStory.dart';
import 'package:Siuu/pages/home/pages/memories/myMemory.dart';
import 'package:Siuu/pages/home/pages/place/map_marker.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/story/controller/story_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowClusters extends StatefulWidget {
  final List<MapMarker> mapMarkers;

  const ShowClusters({
    @required this.mapMarkers,
  });

  @override
  _ShowClustersState createState() => _ShowClustersState();
}

class _ShowClustersState extends State<ShowClusters> {
  List<MapMarker> fixedMapMarkers;
  @override
  void initState() {
    List<String> avatarList = [];
    fixedMapMarkers = [];
    for (MapMarker mapMarker in widget.mapMarkers) {
      if (!avatarList.contains(mapMarker.thumbnailSrc))
        avatarList.add(mapMarker.thumbnailSrc);
    }
    for (String avatar in avatarList) {
      Iterable<MapMarker> whereList =
          widget.mapMarkers.where((element) => element.thumbnailSrc == avatar);
      fixedMapMarkers.add(whereList.first..storyCount = whereList.length);
    }
    fixedMapMarkers.sort((a, b) => b.time.compareTo(a.time));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height / 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        color: Colors.white,
      ),
      child: new Center(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: fixedMapMarkers.length,
          itemBuilder: (context, index) {
            return buildRow(fixedMapMarkers[index]);
          },
        ),
      ),
    );
  }

  buildRow(MapMarker mapMarker) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var openbookProvider = OpenbookProvider.of(context);
    var localizationService = openbookProvider.localizationService;
    var utilsService = openbookProvider.utilsService;
    String created = utilsService.timeAgo(mapMarker.time, localizationService);
    return XGestureDetector(
      onTap: (_) {
        mapMarker.onTap();
      },
      child: Column(
        children: [
          SizedBox(height: width * 0.024),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: width * 0.024),
                  CircleAvatar(
                    radius: 32,
                    foregroundColor: Colors.white,
                    backgroundImage: AdvancedNetworkImage(
                      mapMarker?.thumbnailSrc ?? '',
                      useDiskCache: true,
                      fallbackAssetImage:
                          'assets/images/fallbacks/avatar-fallback.jpg',
                      retryLimit: 0,
                    ),
                  ),
                  SizedBox(width: width * 0.024),
                  Text(
                    mapMarker?.userName ?? '',
                    style: GoogleFonts.openSans(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: width * 0.024),
                  Text(
                    '${mapMarker?.storyCount} moments',
                    style: GoogleFonts.openSans(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    created ?? '',
                    style: GoogleFonts.openSans(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: width * 0.024),
                ],
              ),
            ],
          ),
          SizedBox(height: width * 0.024),
        ],
      ),
    );
  }
}
