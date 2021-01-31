import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:full_chat_app/constant.dart';
import 'package:full_chat_app/helperFunctions/sharedPreferences.dart';
import 'package:full_chat_app/models/user.dart';
import 'package:flutter/cupertino.dart';

class Store {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future addUser(
      {@required String id, @required Map<String, dynamic> data}) async {
    return await _fireStore.collection(KUserCollection).doc(id).set(data);
  }

  Future<Stream<QuerySnapshot>> getUserByName(String username) async {
    return await _fireStore
        .collection('users')
        .where('userName', isEqualTo: username)
        .snapshots();
  }

//  Future<User> getUser(String uId) async {
//    User user;
//    await _fireStore
//        .collection(KUserCollection)
//        .doc(uId)
//        .get()
//        .then((value) => user = User.fromDB(value.data()));
//    return user;
//  }
//
//  Future<Map<String,dynamic>> getUserById(String id) async{
//    return _fireStore.collection(KUserCollection).doc(id).get().then((value) => value.data());
//  }
  Future addMessage(String chatRoomId, String messageId,
      Map messageInfoMap) async {
    _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('chats')
        .doc(messageId)
        .set(messageInfoMap);
  }

  Future updateLastMessageSend(String chatRoomId, Map lastMessageInfo) async {
    return _fireStore
        .collection("chatRooms")
        .doc(chatRoomId)
        .update(lastMessageInfo);
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  createChatRoom(String chatRoomId, Map chatRoomInfo) async {
    final snapshot =
    await _fireStore.collection("chatRooms").doc(chatRoomId).get();
    if (!snapshot.exists) {
      return _fireStore
          .collection("chatRooms")
          .doc(chatRoomId)
          .set(chatRoomInfo);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(String chatRoomId) async {
    return _fireStore
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats").orderBy('ts', descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {

    String myDisplayName = await SharedPreferencesHelper().getDisplayName();
    return _fireStore
        .collection("chatRooms")
        .where("users", arrayContains: myDisplayName).orderBy("lastMessageSendTs", descending: true)
        .snapshots();
  }
  Future<QuerySnapshot> getUserInfo(String displayName) async {
    return await _fireStore
        .collection("users")
        .where("displayName", isEqualTo: displayName)
        .get();
  }

}
