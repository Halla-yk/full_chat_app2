import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper{

  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String displayNameKey = "USERDISPLAYNAMEKEY";
  static String userEmailKey = "USERNAMEKEY";
  static String userProfilePicKey = "USERPROFILEKEY";
 // save data
  Future<bool> saveUsername(String getUsername) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userNameKey, getUsername);
  }
  Future<bool> saveUserId(String getUserId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userIdKey, getUserId);
  }
  Future<bool> saveDisplayName(String getDisplayName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(displayNameKey, getDisplayName);
  }
  Future<bool> saveUserEmail(String getUserEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userEmailKey, getUserEmail);
  }
  Future<bool> saveProfilePicUrl(String getProfilePicUrl) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userProfilePicKey , getProfilePicUrl);
  }

  //get data
  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(displayNameKey);
  }

  Future<String> getUserProfileUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfilePicKey);
  }
}