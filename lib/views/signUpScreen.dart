import 'package:flutter/material.dart';
import 'package:full_chat_app/widgets/widget.dart';
import 'package:full_chat_app/services/auth.dart';
class SignUpScreen extends StatefulWidget {
  final GlobalKey<FormState> _globalkey = GlobalKey<FormState>();
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseServices _auth = FirebaseServices();
  String password, email, username;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    //بتتنفذ لما اطلع من ال page
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Form(
              key: widget._globalkey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });

                    },
                    validator: (value) {
                      if (value == '') {
                        return 'Username is empty';
                      }
                      return null;
                    },
                    controller: _usernameController,
                    style: TextStyle(color: Colors.white),
                    decoration: textFieldDecoration('Username'),
                  ),
                  TextFormField(
                    onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                    },
                    validator: (value) {
                      if (value == '') {
                        return 'Email is empty';
                      }
                      return null;
                    },
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: textFieldDecoration('Email'),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });

                    },
                    validator: (value) {
                      if (value == '') {
                        return 'Password is empty';
                      }
                      return null;
                    },
                    controller: _passwordController,
                    style: TextStyle(color: Colors.white),
                    decoration: textFieldDecoration('Password'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 8,
            ),
            GestureDetector(
                onTap: () async {
                  print(email);
                  print(password);
                  if (widget._globalkey.currentState.validate()) {
                      widget._globalkey.currentState.save();
                    try {

                      final authResult = await _auth.signUp(
                          email.trim(), password.trim());
                      print(authResult.user
                          .uid); //هادا ال id ال firebase هو اللي بعملي اياه

//                      store.addUser(id: authResult.user
//                          .uid,fullName: fullName,dateOfBirth: selectedDate,email: email);
//                      Navigator.pushReplacement(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => HomePage(userId: authResult.user
//                                  .uid,)));
                    } catch (e) {
                      print(e);
//                      Scaffold.of(context).showSnackBar(SnackBar(
//                        content: Text(e
//                            .message), //ممكن الاكسبشن علشان الايميل متكرر او علشان الفورمات غلط تبع الايميل
//                      ));
                    }
                  }
                },
                child: customButton('Sign up', context, Color(0xffffd369))),
            SizedBox(
              height: 16,
            ),
            customButton('Sign up with Google', context, Color(0xffec524b)),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? ",
                    style: TextStyle(color: Colors.white)),
                Text(
                  'Login now',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
      appBar: mainAppBar(context,"Sign up Screen"),
    );
  }
}
