import 'package:flutter/material.dart';
import 'package:full_chat_app/services/auth.dart';
import 'package:full_chat_app/views/home2.dart';
import 'package:full_chat_app/views/loginScreen.dart';
import 'package:full_chat_app/views/signUpScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:full_chat_app/views/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xff393E46)
      ),
      home: FutureBuilder(future: FirebaseServices().getUser(),
        builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot){
        if(snapshot.hasData){
          return Home2();
        }
        else
          return LoginScreen();
        },),
    );
  }
}
