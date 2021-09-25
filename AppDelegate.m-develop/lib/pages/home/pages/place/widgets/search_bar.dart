import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

GoogleMapsPlaces _places =
    GoogleMapsPlaces(apiKey: "AIzaSyBKqejuywJvfKstqhvVa7i-tKL3HetrP0k");

class SearchBar extends StatefulWidget {
  final GoogleMapController googleMapController;
  const SearchBar({
    @required this.googleMapController,
  });
  @override
  SearchBarState createState() => new SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Positioned(
      top: height / 100 * 1,
      left: 0,
      child: Container(
        width: width,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            XGestureDetector(
              onTap: (_) async {
                // show input autocomplete with selected mode
                // then get the Prediction selected
                Prediction p = await PlacesAutocomplete.show(
                  mode: Mode.overlay,
                  context: context,
                  apiKey: "AIzaSyBKqejuywJvfKstqhvVa7i-tKL3HetrP0k",
                  types: [],
                  components: [],
                  strictbounds: false,
                );
                displayPrediction(p);
              },
              child: Container(
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
                  enabled: false,
                  decoration: InputDecoration(
                    icon: SvgPicture.asset(
                      'assets/svg/search.svg',
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            //SizedBox(width: width * 0.024),
            //SvgPicture.asset('assets/svg/rotate.svg')
            currentLocationButton(),
          ],
        ),
      ),
      /*RaisedButton(
          onPressed: () async {
            // show input autocomplete with selected mode
            // then get the Prediction selected
            Prediction p = await PlacesAutocomplete.show(
                context: context, apiKey: "AIzaSyBKqejuywJvfKstqhvVa7i-tKL3HetrP0k");
            displayPrediction(p);
          },
          child: Text('Find address'),

        )*/
    );
  }

  LatLng _initialPosition;
  Future _getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    _initialPosition = LatLng(position.latitude, position.longitude);
  }

  Future<void> goCurrentLocation() async {
    await _getCurrentLocation();
    widget.googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        _initialPosition,
        12,
      ),
    );
  }

  Widget currentLocationButton() {
    return XGestureDetector(
      onTap: (_) async => await goCurrentLocation(),
      child: Container(
        width: 48,
        height: 48,
        child: Card(
          child: Icon(
            Icons.gps_fixed,
            size: 24,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      //var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      //var address = await Geocoder.local.findAddressesFromQuery(p.description);
      widget.googleMapController
          .animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));

      //print(lat);
      //print(lng);
    }
  }
}
