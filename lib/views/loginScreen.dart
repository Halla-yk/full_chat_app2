import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_chat_app/widgets/widget.dart';
import 'package:full_chat_app/services/auth.dart';
class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FirebaseServices services = FirebaseServices();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Form(
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: textFieldDecoration('Email'),
                  ),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: textFieldDecoration('Password'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            customButton('Sign in', context, Color(0xffffd369)),
            SizedBox(
              height: 16,
            ),
            GestureDetector(onTap:(){

              services.signInWithGoogle(context);
                } ,child: customButton('Sign in with Google', context, Color(0xffec524b))),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? ",
                    style: TextStyle(color: Colors.white)),
                Text(
                  'Register now',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
      appBar: mainAppBar(context,"Login Screen"),
    );
  }
}
