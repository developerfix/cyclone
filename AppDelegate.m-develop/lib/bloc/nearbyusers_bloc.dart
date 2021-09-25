import 'dart:async';
import 'dart:developer';
import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/utils/firestore_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
part 'nearbyusers_event.dart';
part 'nearbyusers_state.dart';

class NearbyUsersBloc extends Bloc<NearbyUsersEvent, NearbyUsersState>
    with HydratedMixin {
  final Geoflutterfire geo = Geoflutterfire();
  final Location location = Location();
  final BuildContext context;
  StreamSubscription _positionsStream;

  NearbyUsersBloc(this.context) : super(NearbyUsersInProgress(false)) {
    if (state.isActive) {
      updateLocation();
    }
  }

  @override
  Stream<NearbyUsersState> mapEventToState(NearbyUsersEvent event) async* {
    if (event is NearbyUsersToggled) {
      yield* _mapToggledToState();
    }
  }

  Stream<NearbyUsersState> _mapToggledToState() async* {
    if (!state.isActive) {
      updateLocation();
    } else {
      if (_positionsStream != null) _positionsStream.cancel();
    }
    yield NearbyUsersInProgress(!state.isActive);
  }

  void updateLocation() async {
    print('updateLocation');
    emit(NearbyUsersInProgress(state.isActive));
    try {
      if (await Permission.location.request().isGranted) {
        bool _serviceEnabled;

        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            emit(NearbyUsersLoadFailure(state.isActive));
            return;
          }
        }
        LocationData _locationData = await location.getLocation();

        GeoFirePoint myPoint = geo.point(
            latitude: _locationData.latitude,
            longitude: _locationData.longitude);
        firestore
            .doc(currentUserPath)
            .set({'position': myPoint.data}, SetOptions(merge: true));
        currentUser.setPosition(myPoint);

        var collectionReference = firestore.collection('chatUsers');
        double radius = 1;
        String field = 'position';

        Stream<List<DocumentSnapshot>> nearbyStream =
            geo.collection(collectionRef: collectionReference).within(
                  center: myPoint,
                  radius: radius,
                  field: field,
                  strictMode: true,
                );

        _positionsStream =
            nearbyStream.listen((List<DocumentSnapshot> docs) async {
          print('nearbyStream docs ${docs.length}');

          List<ChatUser> users = [];
          for (var i = 0; i < docs.length; i++) {
            if (docs[i].id == currentUser.id) continue;
            ChatUser user = await fetchUser(docs[i].id, context);
            if (user != null) {
              users.add(user);
            }
          }

          emit(NearbyUsersLoadSuccess(users, state.isActive));
        });
      } else {
        emit(NearbyUsersLoadFailure(state.isActive));
      }
    } catch (e) {
      emit(NearbyUsersLoadFailure(state.isActive));
    }
  }

  @override
  NearbyUsersState fromJson(Map<String, dynamic> json) {
    return NearbyUsersState.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(NearbyUsersState state) {
    return state.toMap();
  }

  @override
  Future<void> close() {
    print('nearbyUsers bloc closed');
    _positionsStream.cancel();
    return super.close();
  }
}
