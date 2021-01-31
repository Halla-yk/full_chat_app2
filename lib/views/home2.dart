import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:full_chat_app/services/auth.dart';
import 'package:full_chat_app/views/loginScreen.dart';
import 'package:full_chat_app/widgets/widget.dart';
import 'package:full_chat_app/services/store.dart';
import 'chatScreen.dart';
import 'package:full_chat_app/helperFunctions/sharedPreferences.dart';

class Home2 extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home2> {
  bool isSearching = false;
  String myUserName, myDisplayName;
  Stream usersStream, chatRoomsStream;
  Store _store = Store();
  TextEditingController searchUsernameEditingController =
      TextEditingController();

  onSearchBtnClick() async {
    isSearching = true;
    setState(() {});
    usersStream =
        await Store().getUserByName(searchUsernameEditingController.text);

    setState(() {});
  }

  getMyInfoFromSharedPreference() async {
    myUserName = await SharedPreferencesHelper().getUserName();
    myDisplayName = await SharedPreferencesHelper().getDisplayName();
    print("my user name" + myUserName);
    setState(() {});
  }

  Widget searchListTile({String profileUrl, displayName, email}) {
    return ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.network(
            profileUrl,
            height: 40,
            width: 40,
          ),
        ),
        title: Text(
          displayName,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          email,
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () {
          print("my2" + myUserName);
          String chatRoomId = _store.getChatRoomIdByUsernames(myDisplayName, displayName);
          print(chatRoomId);
          Map<String, dynamic> chatRoomInfo = {
            "users": [myDisplayName, displayName]
          };
          _store.createChatRoom(chatRoomId, chatRoomInfo);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    displayName: displayName,
                        chatRoomId: chatRoomId,
                      )));
        });
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return  ChatRoomListTile(ds["lastMessage"], ds.id, myDisplayName);
                },
                itemCount: snapshot.data.docs.length,
              )
            : Text('Start conversation with your Friends');
      },
    );
  }

  getChatRooms() async {
    chatRoomsStream = await _store.getChatRooms();
    setState(() {});
  }

  Widget searchUsersList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return searchListTile(
                      profileUrl: ds['profileUrl'],
                      displayName: ds['displayName'],
                      email: ds['email'],
                   );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  @override
  void initState() {
    getMyInfoFromSharedPreference();
    getChatRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff222831),
        title: Text("Messenger Clone"),
        actions: [
          InkWell(
            onTap: () {
              FirebaseServices().signOut().then((s) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                )),
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
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
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
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.red,
                          controller: searchUsernameEditingController,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              hintText: "username",
                              hintStyle: TextStyle(color: Colors.white)),
                        )),
                        GestureDetector(
                            onTap: () {
                              if (searchUsernameEditingController.text != "") {
                                onSearchBtnClick();
                              }
                            },
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            isSearching ? searchUsersList() : chatRoomsList()
          ],
        ),
      ),
    );
  }
}
class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myDisplayName;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myDisplayName);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "",  displayName = "";

  getThisUserInfo() async {
    displayName =
        widget.chatRoomId.replaceAll(widget.myDisplayName, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await Store().getUserInfo(displayName);
   profilePicUrl = await querySnapshot.docs[0]["profileUrl"];
    print(profilePicUrl);

    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(

                  displayName: displayName,
                  chatRoomId: widget.chatRoomId,
                )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child:
              Image.network(
                profilePicUrl,

                height: 40,
                width: 40,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 3),
                Text(widget.lastMessage)
              ],
            )
          ],
        ),
      ),
    );
  }
}