import 'package:flutter/cupertino.dart';
import 'package:full_chat_app/constant.dart';

class User {
  String id;
  String fullName;
  String email;


  User(
      {
        @required this.fullName,
        @required this.id,
        @required this.email,
        });

  factory User.fromDB(Map<String, dynamic> db) {
    return User(
        id: db[KUserId],
        fullName: db[KUserName],
        email: db[KUserEmail],
    );
  }
}