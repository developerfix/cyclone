import 'package:cyclone/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

//create user object based on firebase user
  CycloneUser _userFromFirebaseUser(User firebaseUser) {
    return firebaseUser != null ? CycloneUser(uid: firebaseUser.uid) : null;
  }

//auth State User Stream
  Stream<CycloneUser> get cycloneUser {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

//sign in with Email and password
  // Future signInWithEmailAndPassword(String email, String password) async {
  //   try {
  //     AuthResult result = await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);

  //     FirebaseUser user = result.user;
  //     return userFromFirebaseUser(user);
  //   } catch (e) {
  //     return null;
  //   }
  // }
//Register with Email and Password

  // Future registerUserWithEmailAndPassword(
  //     String email, String username, String password) async {
  //   try {
  //     AuthResult result = await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     FirebaseUser user = result.user;

  //     await DatabaseServices(uid: user.uid).updateUserData(
  //       username: username,
  //       location: 'Add Location',
  //       balance: '0',
  //       cart: {
  //         "itemCount": 0,
  //         "totalMoney": 0,
  //       },
  //       ordersInProgress: 0,
  //     );
  //     return userFromFirebaseUser(user);
  //   } catch (e) {
  //     return null;
  //   }
  // }

  //Sign out

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Reset Password

  Future sendPasswordResetEmail({String email}) async {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
