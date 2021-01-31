import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:full_chat_app/services/auth.dart';
import 'package:full_chat_app/views/loginScreen.dart';
import 'package:full_chat_app/widgets/widget.dart';
import 'package:full_chat_app/services/store.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;
  Stream userStream;
  String myName, myProfilePic, myUserName, myEmail;

  Stream usersStream, chatRoomsStream;

  TextEditingController searchUsernameEditingController =
  TextEditingController();

  onSearchBtnClick() async {
    isSearching = true;
    setState(() {});
    usersStream =
    await Store().getUserByName(searchUsernameEditingController.text);
    setState(() {

    });
   if(userStream == null){
     print('null');
   }

  }

  Widget searchUsersList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData?
            ListView.builder(
          itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Text('found');
          },
        )
            :  Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  chatRoomListTile() {
    print("hhhhhhhh");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        backgroundColor: Color(0xff222831),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseServices().signOut().then((value) =>
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen())));
            },
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                isSearching
                    ? GestureDetector(
                  onTap: () {
                    isSearching = false;
                    searchUsernameEditingController.text = "";
                    setState(() {});
                  },
                  child: Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.arrow_back)),
                )
                    : Container(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                              style: TextStyle(color: Colors.white54),
                              controller: searchUsernameEditingController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Username",
                                  fillColor: Colors.white54),
                            )),
                        GestureDetector(
                            onTap: () {
                              if (searchUsernameEditingController.text != "") {
                                onSearchBtnClick();
                              }
                            },
                            child: Icon(Icons.search, color: Colors.white54,))
                      ],
                    ),
                  ),
                ), isSearching ? searchUsersList() : Center(child:Text('list'))
              ],
            ),

          ],
        ),
      ),
    );
  }


}
