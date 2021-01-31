import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_chat_app/helperFunctions/sharedPreferences.dart';
import 'package:full_chat_app/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:full_chat_app/services/store.dart';
import 'package:random_string/random_string.dart';

class ChatScreen extends StatefulWidget {
  final String  displayName, chatRoomId;

  ChatScreen(
      {
      @required this.displayName,
      @required this.chatRoomId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Store _store = Store();
  String messageId;
  String myName, myProfilePic, myUserName, myEmail;
  Stream chatRoomMessagesStream;
  TextEditingController _textEditingController = TextEditingController();

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferencesHelper().getDisplayName();
    myProfilePic = await SharedPreferencesHelper().getUserProfileUrl();
    myUserName = await SharedPreferencesHelper().getUserName();
    myEmail = await SharedPreferencesHelper().getUserEmail();
    print("user name: "+myUserName+"my display"+myName+"my email"+myEmail);

//    chatRoomId =
//        _store.getChatRoomIdByUsernames(widget.chatWithUsername, widget.name);
  }

  addMessage() {
    if (_textEditingController.text != "") {
      print(_textEditingController.text);
      String message = _textEditingController.text;
      var lastMessageTs = DateTime.now();
      Map<String, dynamic> _messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": lastMessageTs,
        "imgUrl": myProfilePic
      };
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }
      _store
          .addMessage(widget.chatRoomId, messageId, _messageInfoMap)
          .then((value) {
        Map<String, dynamic> _lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": myUserName
        };

        _store.updateLastMessageSend(widget.chatRoomId, _lastMessageInfoMap);
        // remove the text in the message input field
        _textEditingController.text = "";
        // make message id blank to get regenerated on next message send
        messageId = "";
        setState(() {});
      });
    }
  }

  getAndSetMessages() async {
    chatRoomMessagesStream =
        await _store.getChatRoomMessages(widget.chatRoomId);
    setState(() {});
  }

  doThisOnLunch() async {
    await getMyInfoFromSharedPreference();
    getAndSetMessages();
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chatRoomMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return messageTile(ds['message'], myUserName == ds['sendBy']);
                },
                itemCount: snapshot.data.docs.length,
              )
            : Text('Start conversation');
      },
    );
  }

  Widget messageTile(text, bool sendByMe) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints( maxWidth: 200),
          decoration: BoxDecoration(
            color: sendByMe?Color(0xffec524b):Color(0xffffd369),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  bottomRight: sendByMe?Radius.circular(0):Radius.circular(30),
                  bottomLeft: sendByMe?Radius.circular(30):Radius.circular(0))),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
                  ),
      ],
    );
  }

  @override
  void initState() {
    doThisOnLunch();
    print("chat");
    print(widget.chatRoomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff222831),
        title: Text(widget.displayName),
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(child: chatMessages()),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(15),
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: Colors.grey, width: 1, style: BorderStyle.solid)),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _textEditingController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type a message...",
                        hintStyle: TextStyle(color: Colors.white)),
                  )),
                  IconButton(
                    onPressed: () {
                      addMessage();
                    },
                    icon: Icon(Icons.send),
                    color: Color(0xffffd369),
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
