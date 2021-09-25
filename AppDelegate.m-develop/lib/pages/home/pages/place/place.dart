import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:Siuu/models/user.dart';
import 'package:Siuu/pages/home/pages/place/map_marker.dart';
import 'package:Siuu/pages/home/pages/place/widgets/search_bar.dart';
import 'package:Siuu/pages/home/pages/place/widgets/show_clusters.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/story/story_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show NetworkAssetBundle, rootBundle;
import 'package:geocoder/geocoder.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:Siuu/provider.dart';
import 'package:Siuu/models/UserStory.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:Siuu/pages/home/pages/memories/myMemory.dart';

import 'package:Siuu/pages/home/pages/memories/memories.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'map_helper.dart';

import 'package:image/image.dart' as images;

class PlacesPage extends StatefulWidget {
  static Function updateMap;

  @override
  _PlacesPageState createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> with WidgetsBindingObserver {
  //...your code

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _mapController
          .setMapStyle(latestMapStyle)
          .then((value) => setState(() {}));
    }
  }

  GoogleMapController _mapController;
  LatLng _initialPosition;
  UserService _userService;
  UserStory userStoryList;
  NavigationService _navigationService;

  FocusNode keyboardFocus;

  // BitmapDescriptor _markerIcon;
  // Uint8List markerIcon;
  // Marker marker;

  Uint8List markerIcon;

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  void _setMarkerIcon() async {
    markerIcon = await getBytesFromAsset('assets/images/marker.png', 100);

    // _markerIcon = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(), 'assets/images/marker.png');
  }

  Future<void> getStoryList() async {
    userStoryList = await _userService.getStory();
  }

  @override
  void didChangeDependencies() {
    var openbookProvider = OpenbookProvider.of(context);
    _navigationService = openbookProvider.navigationService;
    _userService = openbookProvider.userService;
    listenUserChange();
    getStoryList();
    super.didChangeDependencies();
  }

  StreamSubscription<User> userChange;
  String lastUserAvatar;

  void listenUserChange() {
    if (userChange == null)
      userChange = _userService.getLoggedInUser().updateSubject.listen((event) {
        print('CHANGED AVATAR user: $event');
        if (lastUserAvatar == null) lastUserAvatar = event?.profile?.avatar;
        if (_isMapLoading == true) return;
        if (lastUserAvatar != null && lastUserAvatar == event?.profile?.avatar)
          return;
        _initMarkers();
      });

    /*positionStream =
        Geolocator.getPositionStream(forceAndroidLocationManager: true)
            .listen((Position position) async {
      await stopLocation();
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    });*/
  }

  /*Future<void> stopLocation() async {
    positionStream.pause();
    await positionStream.cancel();
    positionStream = null;
  }*/

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    ).then((Position position) {
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
      // _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    //_customInfoWindowController.googleMapController = controller;

    print('Loc: helloo created map!!!!!!!!!!!');
    Future.delayed(
        const Duration(milliseconds: 550),
        () => setState(() {
              _isMapLoading = false;
            }));

    _initMarkers();

    _setMapStyle();
  }

  List<Story> getsameuserstory(String userId) {
    List<Story> userSameStory = [];
    for (int i = 0; i < userStoryList.onMapStories.length; i++) {
      if (userId == userStoryList.onMapStories[i].userId) {
        userSameStory.add(userStoryList.onMapStories[i]);
      }
    }

    return userSameStory;
  }

  void onClickMarker(Story story) {
    print('marker on CLICKING MARKER');
    List<Story> stories = getsameuserstory(story.userId);
    var user = _userService.getLoggedInUser();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyMemory(
          stories,
          (story.userId == '${user.id}') ? "myStroy" : "userStroy",
          storyController,
        ),
      ),
    );
    /*_customInfoWindowController.addInfoWindow(
      Column(
        children: [
          buildMiniPostBox(story),
          Triangle.isosceles(
            edge: Edge.BOTTOM,
            child: Container(
              color: Colors.blue,
            ),
          ),
        ],
      ),
      LatLng(double.parse(story.lat), double.parse(story.long)),
    ); // lat l*/
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    print('TEST LOAD- INIT MARKERS');
    final List<MapMarker> markers = [];
    print('TEST LOAD- GETTING MARKERS');
    List<MarkerWithFunctions> _markerList = await _getMapStory(userStoryList);
    print('TEST LOAD- GETTED MARKERS');

    _markerList.forEach((markerWithFunctions) async {
      print('TEST LOAD- INIT MARKERS ${markerWithFunctions.avatar}');
      markers.add(
        MapMarker(
          //id: _id.toString(),
          userName: markerWithFunctions.userName,
          position: markerWithFunctions.marker.position,
          icon: markerWithFunctions.marker.icon,
          markerId: markerWithFunctions.marker.markerId.toString(),
          childMarkerId: markerWithFunctions.marker.markerId.toString(),
          thumbnailSrc: markerWithFunctions.avatar,
          onTap: markerWithFunctions.onTap,
          onClusterTap: markerWithFunctions.onClusterTap,
          time: markerWithFunctions.time,
        ),
      );
    });
    /*for (MarkerWithFunctions markerWithFunctions in _markerList) {
      print(
          'Marker ids: ${markerWithFunctions.marker.markerId.toString()}');
      markers.add(
        MapMarker(
          //id: _id.toString(),
          userName: markerWithFunctions.userName,
          position: markerWithFunctions.marker.position,
          icon: markerWithFunctions.marker.icon,
          markerId: markerWithFunctions.marker.markerId.toString(),
          childMarkerId: markerWithFunctions.marker.markerId.toString(),
          thumbnailSrc: markerWithFunctions.avatar,
          onTap: markerWithFunctions.onTap,
          onClusterTap: markerWithFunctions.onClusterTap,
          time: markerWithFunctions.time,
        ),
      );
    }*/

    print('TEST LOAD- INITIN CLUSTER');
    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    print('TEST LOAD- UPDATING MARKERS');
    await _updateMarkers(forceUpdate: true);
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  double lastZoom;
  Future<void> _updateMarkers({bool forceUpdate = false}) async {
    if (_clusterManager == null ||
        (lastZoom == _currentZoom && forceUpdate == false)) return;
    lastZoom = _currentZoom;
    /*setState(() {
      //_areMarkersLoading = true;
    });*/

    print('TEST LOAD- UPDATIN MARKERS 1');
    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );
    print('TEST LOAD- UPDATIN MARKERS 2');

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    print('TEST LOAD- UPDATIN MARKERS 3');
    setState(() {
      //_areMarkersLoading = false;
    });
  }

  Widget buildMiniPostBox(Story story) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(
                width: 8.0,
              ),
              if (story.type == "text")
                Expanded(
                  child: Text(
                    story.text,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.white,
                        ),
                    softWrap: true,
                  ),
                ),
              if (story.type == "image")
                Container(
                  width: 50,
                  height: 50,
                  child: Image.network(
                    story.image,
                  ),
                )
            ],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  Future<BitmapDescriptor> _createBitmapDescriptor(
    String imagePath,
  ) async {
    print('TEST LOAD- CREATING _createBitmapDescriptor');
    var child = await MapHelper.createImage(imagePath, 180, 180);
    print('TEST LOAD- CREATED _createBitmapDescriptor');

    if (child == null) {
      return null;
    }

    images.brightness(child, -25);
    child =
        images.copyCropCircle(child, radius: 90, center: images.Point(90, 90));

    var resized = images.copyResize(child, width: 180, height: 180);

    var png = images.encodePng(resized);
    print('TEST LOAD- RETURNING IMAGE _createBitmapDescriptor');
    return BitmapDescriptor.fromBytes(png);
  }

  Future<MarkerWithFunctions> markerCreator(int i, Story myStories) async {
    print('TEST LOAD- CREATING BitMap');
    var icon = await _createBitmapDescriptor(myStories.avatar);

    return MarkerWithFunctions(
      marker: Marker(
        position:
            LatLng(double.parse(myStories.lat), double.parse(myStories.long)),
        markerId: MarkerId(myStories.id.toString() + i.toString()),
        icon: icon,
        /*infoWindow: InfoWindow(
          title: myStories.name,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyMemory(
                userStoryList.myStories,
                "userStroy",
                storyController,
              ),
            ),
          ),
        ),*/
      ),
      onTap: () => onClickMarker(myStories),
      onClusterTap: (markers) {
        showMaterialModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => ShowClusters(
            mapMarkers: markers,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
          ),
        );
      },
      userName: myStories.name,
      avatar: myStories.avatar,
      time: myStories.time,
    );
  }

  Future<List<MarkerWithFunctions>> _getMapStory(
      UserStory userStoryList) async {
    List<MarkerWithFunctions> storyMarker = [];
    var user = _userService.getLoggedInUser();
    print('TEST LOAD- INITIN _getMapStory');
    if (userStoryList != null) {
      if (userStoryList.onMapStories != null) {
        await Future.wait(userStoryList.onMapStories.map((story) async {
          print('TEST LOAD - FOR GETTING');
          if (story.isSharedOnMap == "true") {
            if (story.userId == '${user.id}') {
              story.avatar = user.profile.avatar;
            }
            var createdMarker = await markerCreator(story.id, story);
            storyMarker.add(createdMarker);
          }
        }));

        /*await Future.forEach<Story>(userStoryList.onMapStories, (story) async {
          print('TEST LOAD - FOR GETTING');
          if (story.isSharedOnMap == "true") {
            if (story.userId == '${user.id}') {
              story.avatar = user.profile.avatar;
            }
            var createdMarker = await markerCreator(story.id, story);
            storyMarker.add(createdMarker);
          }
        });*/
        /*for (int i = 0; i < userStoryList.onMapStories.length; i++) {
          var story = userStoryList.onMapStories[i];
          if (story.isSharedOnMap == "true") {
            if (story.userId == '${user.id}') {
              story.avatar = user.profile.avatar;
            }
            var createdMarker = await markerCreator(i, story);
            storyMarker.add(createdMarker);
          }
        }*/
      }
      /*if (userStoryList.stories != null) {
        for (int i = 0; i < userStoryList.stories.length; i++) {
          if (userStoryList.stories[i].isSharedOnMap == "true") {
            var createdMarker =
                await markerCreator(i, userStoryList.stories[i]);
            storyMarker.add(createdMarker);
          }
        }
      }*/
    }
    print('TEST LOAD- GETTED LIST _getMapStory');
    storyMarker.sort((a, b) => b.time.compareTo(a.time));
    return storyMarker;
  }

  String latestMapStyle;
  void _setMapStyle() async {
    latestMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _mapController.setMapStyle(latestMapStyle);
  }

  Function updateMap() {
    getStoryList().then((value) => _initMarkers());
    return null;
  }

  StoryController storyController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setMarkerIcon();
    _getCurrentLocation();
    storyController = StoryController();
    keyboardFocus = FocusNode();
    PlacesPage.updateMap = updateMap;
  }

  @override
  void dispose() {
    //_customInfoWindowController.dispose();
    userChange.pause();
    userChange = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //getStoryList();
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: false,
        body: _initialPosition != null
            ? Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Opacity(
                      opacity: _isMapLoading ? 0 : 1,
                      child: XGestureDetector(
                        onMoveStart: (_) {
                          keyboardFocus.unfocus();
                        },
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _initialPosition,
                            zoom: _currentZoom,
                          ),
                          myLocationEnabled: false,
                          zoomControlsEnabled: false,
                          // onCameraMove: _onCameraMove,

                          myLocationButtonEnabled: true,
                          mapToolbarEnabled: true,
                          zoomGesturesEnabled: true,
                          markers: _markers,
                          onCameraMove: (position) {
                            //_customInfoWindowController.onCameraMove();
                            _currentZoom = position.zoom;
                          },
                          onCameraIdle: () {
                            _updateMarkers();
                          },
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: _isMapLoading ? 1 : 0,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  /*CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: 250,
                    width: 150,
                    offset: 50,
                  ),*/
                  ...buildPageWidgets(width, height),
                ],
              )
            : Text(""),
      ),
    );
  }

  List<Widget> buildPageWidgets(width, height) {
    return [
      //buildCollapsedAvatars(width, height),
      buildTopBar(width, height),
      //buildRefreshButton(width, height),
      buildLatestComments(width, height),
    ];
  }

  /*Widget buildRefreshButton(width, height) {
    return Positioned(
      top: height / 100 * 9,
      right: width / 100 * 2,
      child: XGestureDetector(
        onTap: (_) {
          //TODO Refresh function
        },
        child: Container(
          width: 44,
          height: 44,
          child: Card(
            color: Colors.white,
            elevation: 5,
            child: Container(
              width: 24,
              height: 24,
              child: Center(
                child: SvgPicture.asset('assets/svg/rotate.svg'),
              ),
            ),
          ),
        ),
      ),
    );
  }*/

  Widget buildTopBar(width, height) {
    return SearchBar(
      googleMapController: _mapController,
    );
    /*return Positioned(
      top: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20),
            height: height * 0.057,
            width: width * 0.777,
            decoration: BoxDecoration(
              color: Color(0xffffffff).withOpacity(0.68),
              border: Border.all(
                width: width * 0.002,
                color: Color(0xff433f59).withOpacity(0.68),
              ),
              borderRadius: BorderRadius.circular(30.00),
            ),
            child: TextFormField(
              focusNode: keyboardFocus,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 10),
                  icon: SvgPicture.asset(
                    'assets/svg/search.svg',
                  ),
                  border: InputBorder.none),
            ),
          ),
          SizedBox(width: width * 0.024),
          SvgPicture.asset('assets/svg/rotate.svg')
        ],
      ),
    );*/
  }

  /*Widget buildCollapsedAvatars(width, height) {
    return Align(
      alignment: Alignment.center,
      child: new Container(
        height: height * 0.0585,
        width: width * 0.2430,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.00, 20.00),
              color: Color(0xff000000).withOpacity(0.16),
              blurRadius: 20,
            ),
          ],
          borderRadius: BorderRadius.circular(40.00),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment(-1, 1),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3)),
                height: height * 0.0541,
                width: width * 0.0945,
                child: Image.asset(
                  'assets/images/person1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment(-0.2, 1),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3)),
                height: height * 0.0541,
                width: width * 0.0945,
                child: Image.asset(
                  'assets/images/person1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.8, 1),
              child: new Container(
                height: height * 0.0541,
                width: width * 0.0945,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: linearGradient,
                ),
                child: Center(
                  child: new Text(
                    "+5",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Arial",
                      fontSize: 11,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }*/

  Widget buildLatestComments(width, height) {
    var user = _userService.getLoggedInUser();
    List<Story> latestMoments = [];
    if (userStoryList != null) {
      if (userStoryList.onMapStories != null) {
        var maxMoments = 50;
        var currentMomentsCount = 0;
        for (int i = userStoryList.onMapStories.length - 1; i >= 0; i--) {
          var story = userStoryList.onMapStories[i];
          if (story.userId == '${user.id}') continue;
          if (story.text == null || story.text == '') continue;
          if (currentMomentsCount >= maxMoments) break;
          latestMoments.add(story);
          currentMomentsCount += 1;
        }
      }
      /*if (userStoryList.stories != null) {
        for (int i = 0; i < userStoryList.stories.length; i++) {
          if (userStoryList.stories[i].isSharedOnMap == "true") {
            var createdMarker =
                await markerCreator(i, userStoryList.stories[i]);
            storyMarker.add(createdMarker);
          }
        }
      }*/
    }
    return Positioned(
      bottom: 10,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: height * 0.161,
          maxHeight: height * 0.161,
          maxWidth: width,
          minWidth: width / 2,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: latestMoments.length,
          itemBuilder: (context, index) {
            return buildListViewContainer(latestMoments[index]);
          },
        ),
      ),
    );
  }

  Widget buildListViewContainer(Story story) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    Future _adressFuture = _getAddressFromLatLng(story);
    return GestureDetector(
      onTap: () {
        onClickMarker(story);
      },
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Container(
          height: height * 0.161,
          width: width * 0.580,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                offset: Offset(0.00, 20.00),
                color: Color(0xff000000).withOpacity(0.16),
                blurRadius: 20,
              ),
            ],
            borderRadius: BorderRadius.circular(5.00),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.073,
                          width: width * 0.121,
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(story.avatar),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        Container(
                          width: width / 100 * 1,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.015),
                            buildText(
                              color: 0xff4D0CBB,
                              maxfontsize: 13,
                              minfontsize: 11,
                              text: story.name,
                            ),
                            FutureBuilder<String>(
                              future: _adressFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done)
                                  return buildText(
                                    maxfontsize: 11,
                                    minfontsize: 9,
                                    color: 0xff97abb3,
                                    text: '${snapshot?.data}',
                                  );
                                else
                                  return Container();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _mapController.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            LatLng(
                              double.parse(story.lat),
                              double.parse(story.long),
                            ),
                            12,
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.transparent,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/marker.svg',
                              color: Color(0xff3e494e),
                            ),
                            SizedBox(width: width * 0.024),
                            buildText(
                              maxfontsize: 9,
                              minfontsize: 7,
                              color: 0xff97abb3,
                              text: '${_getDistanceFromLatLng(story)} km',
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: width / 100 * 1,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: buildText(
                        color: 0xff97abb3,
                        maxfontsize: 10,
                        minfontsize: 10,
                        fontWeight: FontWeight.w300,
                        text: story.text,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDistanceFromLatLng(Story story) {
    var distance = Geolocator.distanceBetween(
        double.parse(story.lat),
        double.parse(story.long),
        _initialPosition.latitude,
        _initialPosition.longitude);

    return (distance / 1000).toStringAsFixed(0);
  }

  Future<String> _getAddressFromLatLng(Story story) async {
    final coordinates = new Coordinates(
      double.parse(story.lat),
      double.parse(story.long),
    );
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    String result = first.locality ??
        first.subAdminArea ??
        first.adminArea ??
        first.countryName;
    return result;
  }

  AutoSizeText buildText(
      {String text,
      double maxfontsize,
      double minfontsize,
      FontWeight fontWeight,
      double fontSize,
      int color}) {
    return AutoSizeText(
      text,
      maxFontSize: maxfontsize,
      minFontSize: minfontsize,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontWeight: fontWeight,
        // fontSize: fontSize,
        color: Color(color),
      ),
    );
  }

  Future<void> customMarker() async {
    var image =
        Uri.parse("https://i.ytimg.com/vi/KVskRMXepSU/maxresdefault.jpg");
    final Uint8List markerIcon = await getBytesFrompath(image, 100);
    print("::::::$markerIcon");
    setState(() {
      // dataBytes = markerIcon;
    });
  }

  Future<Uint8List> getBytesFrompath(path, width) async {
    var request = await http.get(path);
    var bytes = await request.bodyBytes;

    ui.Codec codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
