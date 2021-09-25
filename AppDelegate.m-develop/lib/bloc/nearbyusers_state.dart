part of 'nearbyusers_bloc.dart';

class NearbyUsersState {
  final bool isActive;

  NearbyUsersState(this.isActive);

  Map<String, dynamic> toMap() {
    if (!isActive) {
      firestore
          .doc(currentUserPath)
          .set({'position': null}, SetOptions(merge: true));
      currentUser.setPosition(null);
    }

    return {'isActive': isActive};
  }

  factory NearbyUsersState.fromMap(Map<String, dynamic> map) {
    return NearbyUsersState(map['isActive']);
  }
}

class NearbyUsersInProgress extends NearbyUsersState {
  NearbyUsersInProgress(bool isActive) : super(isActive);
}

class NearbyUsersLoadSuccess extends NearbyUsersState {
  final List<ChatUser> users;

  NearbyUsersLoadSuccess(this.users, bool isActive) : super(isActive);
}

class NearbyUsersLoadFailure extends NearbyUsersState {
  NearbyUsersLoadFailure(bool isActive) : super(isActive);
}
