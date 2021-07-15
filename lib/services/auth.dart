import 'package:cyclone/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin _facebookLogin = FacebookLogin();
  GoogleSignIn _googleSignIn = new GoogleSignIn();

//create user object based on firebase user
  CycloneUser _userFromFirebaseUser(User firebaseUser) {
    return firebaseUser != null
        ? CycloneUser(
            uid: firebaseUser.uid,
            name: firebaseUser.displayName,
            photoURL: firebaseUser.photoURL)
        : null;
  }

//auth State User Stream
  Stream<CycloneUser> get cycloneUser {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

// sign in with Email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }
// Register with Email and Password

  Future registerUserWithEmailAndPassword(
      String email, String username, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  //LoginWithFacebook

  Future handleFacebookLogin() async {
    final FacebookLoginResult result = await _facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        return null;
        break;
      case FacebookLoginStatus.error:
        return null;
        break;
      case FacebookLoginStatus.loggedIn:
        try {
          await loginWithfacebook(result);
        } catch (e) {
          print(e);
          return null;
        }
        break;
    }
  }

  Future loginWithfacebook(FacebookLoginResult result) async {
    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);

    try {
      var a = await _auth.signInWithCredential(credential);

      User user = a.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  //Google Sign in

  Future handleGoogleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    try {
      UserCredential result = await _auth.signInWithCredential(credential);

      User user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  //Sign out

  Future signOut() async {
    try {
      return await _auth.signOut().whenComplete(() {
        _facebookLogin.logOut();
        _googleSignIn.signOut();
      });
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
