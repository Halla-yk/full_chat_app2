import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:full_chat_app/helperFunctions/sharedPreferences.dart';
import 'package:full_chat_app/services/store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:full_chat_app/views/home2.dart';
class FirebaseServices {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Store _store = Store();

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    final UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return authResult;
  }

  Future<UserCredential> signUp(String email, String password) async {
    final UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user;
  }

  void signInWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount _googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleSignInAuthentication =
        await _googleSignInAccount.authentication;
    final AuthCredential _credential = GoogleAuthProvider.credential(
        idToken: _googleSignInAuthentication.idToken,
        accessToken: _googleSignInAuthentication.accessToken);
    UserCredential userCredential =
        await _auth.signInWithCredential(_credential);
    User userDetails = userCredential.user;
    var userName =  userDetails.email.replaceAll("@gmail.com", "");
    if (userCredential == null) {
    } else {
      SharedPreferencesHelper().saveUserEmail(userDetails.email);
      SharedPreferencesHelper().saveUserId(userDetails.uid);
      SharedPreferencesHelper().saveUsername(userName);
      SharedPreferencesHelper().saveDisplayName(userDetails.displayName);
      SharedPreferencesHelper().saveProfilePicUrl(userDetails.photoURL);
      Map<String, dynamic> data = {
        "displayName": userDetails.displayName,
        "email": userDetails.email,
        "userName": userDetails.email.replaceAll("@gmail.com", ""),
        "userId": userDetails.uid,
        "profileUrl": userDetails.photoURL
      };
      print( userDetails.email.replaceAll("@gmail.com", ""));

      _store.addUser(id: userDetails.uid, data: data).then((value) =>
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home2()))
          ); //the value is doc id

    }
  }

   getUser() async{
    return await _auth.currentUser;
  }
  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await _auth.signOut();
  }
}
